import 'package:fitness_app/core/services/profile_guard_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:fitness_app/features/appointment/domain/entities/appointment.dart';
import 'package:fitness_app/app/injection_container.dart';
import 'package:fitness_app/features/appointment/presentation/get_appointments/bloc/calendar_bloc.dart';
import 'package:fitness_app/features/appointment/presentation/get_appointments/bloc/calendar_event.dart';
import 'package:fitness_app/features/appointment/presentation/get_appointments/bloc/calendar_state.dart';
import 'package:fitness_app/features/appointment/presentation/get_appointments/bloc/event_bloc.dart';
import 'package:fitness_app/features/appointment/presentation/get_appointments/bloc/event_event.dart';
import 'package:fitness_app/features/appointment/presentation/get_appointments/bloc/event_state.dart';
import 'package:fitness_app/features/appointment/presentation/get_appointments/widgets/appointment_event_tile.dart';
import 'package:fitness_app/features/appointment/presentation/get_appointments/widgets/appointment_calendar.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';
import 'package:fitness_app/core/widgets/user_avatar_action.dart';
import 'package:fitness_app/core/widgets/main_menu_button.dart';
import 'package:fitness_app/app/app_router.dart';
import 'package:fitness_app/core/navigation/routes.dart';
import 'package:fitness_app/features/appointment/domain/usecases/sync.dart';
import 'package:fitness_app/features/appointment/domain/entities/sync.dart';
import 'package:fitness_app/core/services/availability_service.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final CalendarBloc calendarBloc = sl<CalendarBloc>();
  final EventBloc eventBloc = sl<EventBloc>();
  final Sync _sync = sl<Sync>();
  final AppointmentAvailabilityService availabilityService =
      sl<AppointmentAvailabilityService>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    calendarBloc.add(const CalendarInitialized());
    _loadTrainerMap();
  }

  void refreshPage() {
    calendarBloc.add(const CalendarInitialized());
  }

  Future<void> _loadTrainerMap() async {
    try {
      // Use the signed-in user's email (value is unused by backend, but avoids magic strings)
      final email = sharedPreferences.getString('user_email') ?? '';
      final result = await _sync(email);
      result?.fold((failure) {
        // ignore failure; fallback titles will be used
      }, (syncEntity) {
        final SyncEntity sync = syncEntity;
        final map = <int, String>{
          for (final t in sync.data.trainers) t.id: t.name,
        };
        setState(() => _trainerNameById = map);
      });
    } finally {}
  }

  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  final SharedPreferences sharedPreferences = sl<SharedPreferences>();
  Map<int, String> _trainerNameById = {};
  final Map<int, String> _clientNameById = {};
  final Map<int, Future<String>> _pendingClientNameById = {};
  Set<DateTime> _availabilityDays = {};
  int? _selectedTrainerFilterId;
  String? _availabilityToken;

  @override
  void dispose() {
    calendarBloc.close();
    eventBloc.close();
    super.dispose();
  }

  Future<String> _getClientDisplayById(int userId) async {
    if (userId == 0) return 'User #0';
    final cached = _clientNameById[userId];
    if (cached != null && cached.isNotEmpty) return cached;
    final pending = _pendingClientNameById[userId];
    if (pending != null) return pending;

    Future<String> loader() async {
      try {
        final users = await _firestore
            .collection('users')
            .where('id', isEqualTo: userId)
            .limit(1)
            .get();
        if (users.docs.isEmpty) return 'User #$userId';
        final doc = users.docs.first;
        final uid = doc.id;
        final email = (doc.data()['email'] as String?)?.trim() ?? '';
        try {
          final prof = await _firestore.collection('profiles').doc(uid).get();
          final data = prof.data();
          final name = (data?['name'] as String?)?.trim() ?? '';
          final display =
              name.isNotEmpty ? name : (email.isNotEmpty ? email : 'User #$userId');
          _clientNameById[userId] = display;
          return display;
        } catch (_) {
          final display = email.isNotEmpty ? email : 'User #$userId';
          _clientNameById[userId] = display;
          return display;
        }
      } catch (_) {
        return 'User #$userId';
      } finally {
        _pendingClientNameById.remove(userId);
      }
    }

    final fut = loader();
    _pendingClientNameById[userId] = fut;
    return fut;
  }

  DateTime _monthStart(DateTime d) => DateTime(d.year, d.month, 1);
  DateTime _monthEnd(DateTime d) => DateTime(d.year, d.month + 1, 0);

  Future<void> _loadAvailabilityForVisibleMonth(DateTime focus) async {
    try {
      final start = _monthStart(focus).subtract(const Duration(days: 7));
      final end = _monthEnd(focus).add(const Duration(days: 7));
      Set<DateTime> set;
      // Respect explicit filter; otherwise, when in trainer mode, default to own availability
      final role = sharedPreferences.getString('role');
      final int? trainerIdToUse = _selectedTrainerFilterId ??
          ((role == 'trainer') ? (sharedPreferences.getInt('user_id') ?? 0) : null);
      final token =
          '${trainerIdToUse ?? 0}|${start.millisecondsSinceEpoch}|${end.millisecondsSinceEpoch}';
      _availabilityToken = token;
      if (trainerIdToUse != null && trainerIdToUse > 0) {
        set = await availabilityService.listAvailableDatesInRangeForTrainer(
          trainerId: trainerIdToUse,
          start: start,
          end: end,
        );
      } else {
        set = await availabilityService.listAvailableDatesInRange(
          start: start,
          end: end,
        );
      }
      if (!mounted) return;
      if (_availabilityToken == token) {
        setState(() => _availabilityDays = set);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    final isTrainer = sharedPreferences.getString('role') == "trainer";
    final isAdmin = sharedPreferences.getString('role') == "admin";

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: ColorManager.darkWhite,
        floatingActionButton: !(isTrainer || isAdmin)
            ? FloatingActionButton(
                heroTag: 'calendarFab',
                backgroundColor: ColorManager.primary,
                child: const Icon(Icons.add),
                onPressed: () {
                  calendarBloc.add(CalendarAddButtonClicked(selectedDay: _focusedDay));
                },
              )
            : null,
        appBar: AppBar(
          backgroundColor: ColorManager.primary,
          title: Text(strings.titleAppointmentLabel),
          centerTitle: true,
          leading: const MainMenuButton(),
          actions: const [UserAvatarAction()],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            refreshPage();
            await _loadTrainerMap();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: <Widget>[
                // Quick actions row
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: Row(
                    children: [
                      OutlinedButton.icon(
                        icon: const Icon(Icons.today),
                        label: const Text('Today'),
                        onPressed: () {
                          final now = DateTime.now();
                          setState(() {
                            _focusedDay = now;
                            _selectedDay = now;
                          });
                          calendarBloc.add(const CalendarInitialized());
                          _loadAvailabilityForVisibleMonth(now);
                        },
                      ),
                      const SizedBox(width: 12),
                      if (!isTrainer)
                        Expanded(
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Filter by trainer',
                              border: OutlineInputBorder(),
                              isDense: true,
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<int?>(
                                value: _selectedTrainerFilterId,
                                isDense: true,
                                isExpanded: true,
                                items: [
                                  const DropdownMenuItem<int?>(
                                    value: null,
                                    child: Text('All trainers'),
                                  ),
                                  ..._trainerNameById.entries
                                      .map((e) => DropdownMenuItem<int?>(
                                            value: e.key,
                                            child: Text(e.value.isEmpty
                                                ? 'Trainer #${e.key}'
                                                : e.value),
                                          )),
                                ],
                                onChanged: (v) {
                                  setState(() => _selectedTrainerFilterId = v);
                                  _loadAvailabilityForVisibleMonth(_focusedDay);
                                },
                              ),
                            ),
                          ),
                        )
                      else
                        Text(
                          'Trainer mode',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: ColorManager.grey),
                        ),
                    ],
                  ),
                ),
                BlocConsumer<CalendarBloc, CalendarState>(
                    bloc: calendarBloc,
                    listenWhen: (previous, current) => current is CalendarActionState,
                    buildWhen: (previous, current) => current is! CalendarActionState,
                    listener: (context, state) async {
                      if (state is CalendarNavigateToAddActionState) {
                        // Block admins from booking appointments
                        final isAdmin = sharedPreferences.getString('role') == "admin";
                        if (isAdmin) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Admins cannot book appointments.')),
                          );
                          return;
                        }
                        final canProceed = await sl<ProfileGuardService>().isComplete();
                        if (!context.mounted) return;
                        if (!canProceed) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Please complete your profile to book appointments.')),
                          );
                          AppRouter.router.push(Routes.profile);
                          return;
                        }
                        if (!context.mounted) return;
                        AppRouter.router.push(
                          Routes.addAppointment,
                          extra: {
                            'focusedDay': state.focusedDay,
                            'preselectedTrainerId': _selectedTrainerFilterId,
                          },
                        ).then((_) => refreshPage());
                      } else if (state is CalendarNavigateToDetailPageActionState) {
                        // Details page no longer required. Ignore or open edit when trainer.
                        if (!mounted) return;
                        final isTrainer =
                            sharedPreferences.getString('role') == "trainer";
                        if (isTrainer) {
                          AppRouter.router.push(
                            Routes.addAppointment,
                            extra: {
                              'focusedDay': state.appointment.date,
                              'appointment': state.appointment,
                            },
                          ).then((_) => refreshPage());
                        }
                      } else if (state is CalendarNavigateToUpdatePageActionState) {
                      } else if (state is CalendarItemDeletedActionState) {
                        calendarBloc.add(const CalendarInitialized());
                      } else if (state is CalendarItemUpdatedActionState) {
                        calendarBloc.add(const CalendarInitialized());
                      } else if (state is CalendarItemsDeletedActionState) {
                      } else if (state is CalendarShowErrorActionState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      }
                    },
                    builder: (context, state) {
                      switch (state.runtimeType) {
                        case CalendarLoadingState:
                          return const Center(
                            child: LinearProgressIndicator(),
                          );

                        case CalendarLoadedSuccessState:
                          final successState = state as CalendarLoadedSuccessState;
                          final List<Appointment> allEvents = successState.appointments;
                          // Apply trainer filter (dropdown) or default to self when in trainer mode
                          final int? trainerIdForView = _selectedTrainerFilterId ??
                              ((sharedPreferences.getString('role') == 'trainer')
                                  ? (sharedPreferences.getInt('user_id') ?? 0)
                                  : null);
                          final List<Appointment> visibleEvents =
                              (trainerIdForView == null || trainerIdForView == 0)
                                  ? allEvents
                                  : allEvents
                                      .where((e) => e.trainerId == trainerIdForView)
                                      .toList();
                          eventBloc.add(EventDaySelectEvent(
                              selectedDay: _focusedDay, appointments: visibleEvents));
                          // Load availability around the current page focus
                          _loadAvailabilityForVisibleMonth(_focusedDay);
                          return AppointmentCalendar(
                            focusedDay: _focusedDay,
                            selectedDay: _selectedDay,
                            calendarFormat: _calendarFormat,
                            onDaySelected: (selectedDay, focusedDay) {
                              // Respect trainer filter (or trainer mode default) when switching days
                              final int? trainerIdForView = _selectedTrainerFilterId ??
                                  ((sharedPreferences.getString('role') == 'trainer')
                                      ? (sharedPreferences.getInt('user_id') ?? 0)
                                      : null);
                              final List<Appointment> visibleEvents =
                                  (trainerIdForView == null || trainerIdForView == 0)
                                      ? allEvents
                                      : allEvents
                                          .where((e) => e.trainerId == trainerIdForView)
                                          .toList();
                              eventBloc.add(EventDaySelectEvent(
                                  selectedDay: selectedDay, appointments: visibleEvents));
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = selectedDay;
                              });
                            },
                            onPageChanged: (focusedDay) {
                              _focusedDay = focusedDay;
                              _loadAvailabilityForVisibleMonth(focusedDay);
                            },
                            onFormatChanged: (format) {
                              if (_calendarFormat != format) {
                                setState(() {
                                  _calendarFormat = format;
                                });
                              }
                            },
                            // Show dots only for events matching the current filter (if any)
                            eventLoader: (day) {
                              final int? trainerIdForView = _selectedTrainerFilterId ??
                                  ((sharedPreferences.getString('role') == 'trainer')
                                      ? (sharedPreferences.getInt('user_id') ?? 0)
                                      : null);
                              final List<Appointment> visibleEvents =
                                  (trainerIdForView == null || trainerIdForView == 0)
                                      ? allEvents
                                      : allEvents
                                          .where((e) => e.trainerId == trainerIdForView)
                                          .toList();
                              return visibleEvents
                                  .where((event) => isSameDay(event.date, day))
                                  .toList();
                            },
                            availabilityDays: _availabilityDays,
                          );

                        case CalendarErrorState:
                          final error = state as CalendarErrorState;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                            child: Center(child: Text(error.message)),
                          );
                        default:
                          return const SizedBox();
                      }
                    }),
                BlocConsumer<EventBloc, EventState>(
                  bloc: eventBloc,
                  listenWhen: (previous, current) => current is EventActionState,
                  buildWhen: (previous, current) => current is! EventActionState,
                  listener: (context, state) {
                    if (state is EventNavigateToUpdatePageActionState) {
                      if (!mounted) return;
                      AppRouter.router.push(
                        Routes.addAppointment,
                        extra: {
                          'focusedDay': state.focusedDay,
                          'appointment': state.appointment,
                        },
                      ).then(
                        (value) => refreshPage(),
                      );
                    }
                  },
                  builder: (context, state) {
                    switch (state.runtimeType) {
                      case EventLoadingState:
                        return const Center(
                          child: CircularProgressIndicator(),
                        );

                      case EventDaySelectedState:
                        final successState = state as EventDaySelectedState;
                        final selectedEvents = [...successState.appointments]
                          ..sort((a, b) => a.startTime.compareTo(b.startTime));
                        if (selectedEvents.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                            child: Center(
                              child: Text(
                                'No appointments for this day.',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: selectedEvents.length,
                          itemBuilder: (context, index) {
                            final Appointment appointmentModel = selectedEvents[index];
                            final String title =
                                _trainerNameById[appointmentModel.trainerId] ??
                                    'Trainer #${appointmentModel.trainerId}';
                            final String status = (appointmentModel.status).toLowerCase();
                            final bool canActOnPending = isTrainer && status == 'pending';
                            if (isTrainer) {
                              return FutureBuilder<String>(
                                future: _getClientDisplayById(appointmentModel.userId),
                                builder: (context, snap) {
                                  final display =
                                      snap.data ?? 'User #${appointmentModel.userId}';
                                  return AppointmentEventTile(
                                    title: display,
                                    startTime: appointmentModel.startTime,
                                    endTime: appointmentModel.endTime,
                                    trainerName:
                                        _trainerNameById[appointmentModel.trainerId] ??
                                            'Trainer #${appointmentModel.trainerId}',
                                    clientName: display,
                                    remarks: appointmentModel.remark ?? '',
                                    trailing: _StatusChip(status: status),
                                    onTap: () {
                                      if (!mounted) return;
                                      AppRouter.router.push(
                                        Routes.addAppointment,
                                        extra: {
                                          'focusedDay': _focusedDay,
                                          'appointment': appointmentModel,
                                        },
                                      ).then((_) => refreshPage());
                                    },
                                    onEdit: canActOnPending
                                        ? () {
                                            calendarBloc.add(
                                              CalendarStatusChangeRequested(
                                                appointment: appointmentModel,
                                                status: 'accepted',
                                              ),
                                            );
                                          }
                                        : null,
                                    onDelete: canActOnPending
                                        ? () {
                                            calendarBloc.add(
                                              CalendarStatusChangeRequested(
                                                appointment: appointmentModel,
                                                status: 'declined',
                                              ),
                                            );
                                          }
                                        : null,
                                    editLabel: canActOnPending ? 'Accept' : null,
                                    deleteLabel: canActOnPending ? 'Decline' : null,
                                    editIcon: canActOnPending ? Icons.check : null,
                                    deleteIcon: canActOnPending ? Icons.close : null,
                                    editActionColor:
                                        canActOnPending ? Colors.green : null,
                                    deleteActionColor:
                                        canActOnPending ? Colors.orange : null,
                                    actionForegroundColor:
                                        canActOnPending ? Colors.white : null,
                                  );
                                },
                              );
                            } else {
                              return AppointmentEventTile(
                                title: title,
                                startTime: appointmentModel.startTime,
                                endTime: appointmentModel.endTime,
                                trainerName: title,
                                clientName: 'Me',
                                remarks: appointmentModel.remark ?? '',
                                trailing: _StatusChip(status: status),
                                onTap: () {
                                  if (!mounted) return;
                                  // Non-trainer: no action on tap
                                },
                                onEdit: null,
                                onDelete: null,
                              );
                            }
                          },
                        );
                      case EventErrorState:
                        final error = state as EventErrorState;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: Center(child: Text(error.message)),
                        );
                      default:
                        return const SizedBox();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status; // pending | accepted | declined
  const _StatusChip({required this.status});

  Color _bg(BuildContext context) {
    switch (status) {
      case 'accepted':
        return Colors.green.withValues(alpha: 0.1);
      case 'declined':
        return Colors.red.withValues(alpha: 0.1);
      default:
        return Colors.orange.withValues(alpha: 0.1);
    }
  }

  Color _fg(BuildContext context) {
    switch (status) {
      case 'accepted':
        return Colors.green.shade700;
      case 'declined':
        return Colors.red.shade700;
      default:
        return Colors.orange.shade800;
    }
  }

  String _label() {
    if (status == 'accepted') return 'Accepted';
    if (status == 'declined') return 'Declined';
    return 'Pending';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _bg(context),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _fg(context).withValues(alpha: 0.2)),
      ),
      child: Text(
        _label(),
        style: Theme.of(context)
            .textTheme
            .labelMedium
            ?.copyWith(color: _fg(context), fontWeight: FontWeight.w700),
      ),
    );
  }
}

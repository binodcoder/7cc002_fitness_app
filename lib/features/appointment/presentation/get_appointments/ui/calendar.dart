import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:fitness_app/features/appointment/domain/entities/appointment.dart';
import 'package:fitness_app/drawer.dart';
import 'package:fitness_app/injection_container.dart';
import 'package:fitness_app/features/appointment/presentation/get_appointments/bloc/calendar_bloc.dart';
import 'package:fitness_app/features/appointment/presentation/get_appointments/bloc/calendar_event.dart';
import 'package:fitness_app/features/appointment/presentation/get_appointments/bloc/calendar_state.dart';
import 'package:fitness_app/features/appointment/presentation/get_appointments/bloc/event_bloc.dart';
import 'package:fitness_app/features/appointment/presentation/get_appointments/bloc/event_event.dart';
import 'package:fitness_app/features/appointment/presentation/get_appointments/bloc/event_state.dart';
import 'package:fitness_app/features/appointment/presentation/get_appointments/ui/appointment_details.dart';
import 'package:fitness_app/features/appointment/presentation/get_appointments/widgets/appointment_event_tile.dart';
import 'package:fitness_app/features/appointment/presentation/get_appointments/widgets/appointment_calendar.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';

import '../../appointment_form/ui/appointment_form_dialog.dart';
import 'package:fitness_app/features/appointment/domain/usecases/sync.dart';
import 'package:fitness_app/features/appointment/domain/entities/sync.dart';

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
      final result = await _sync("donotdeleteordublicate@wlv.ac.uk");
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

  @override
  void dispose() {
    calendarBloc.close();
    eventBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    final isTrainer = sharedPreferences.getString('role') == "trainer";

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: ColorManager.darkWhite,
        drawer: const MyDrawer(),
        floatingActionButton: FloatingActionButton(
          backgroundColor: ColorManager.primary,
          child: const Icon(Icons.add),
          onPressed: () {
            calendarBloc
                .add(CalendarAddButtonClicked(selectedDay: _focusedDay));
          },
        ),
        appBar: AppBar(
          backgroundColor: ColorManager.primary,
          title: Text(strings.titleAppointmentLabel),
          centerTitle: true,
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
                BlocConsumer<CalendarBloc, CalendarState>(
                    bloc: calendarBloc,
                    listenWhen: (previous, current) =>
                        current is CalendarActionState,
                    buildWhen: (previous, current) =>
                        current is! CalendarActionState,
                    listener: (context, state) {
                      if (state is CalendarNavigateToAddActionState) {
                        if (!mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                AppointmentFormDialog(
                                    focusedDay: state.focusedDay),
                            fullscreenDialog: true,
                          ),
                        ).then(
                          (value) => refreshPage(),
                        );
                      } else if (state
                          is CalendarNavigateToDetailPageActionState) {
                        if (!mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                AppointmentDetailsPage(
                              appointment: state.appointment,
                            ),
                            fullscreenDialog: true,
                          ),
                        ).then(
                          (value) => refreshPage(),
                        );
                      } else if (state
                          is CalendarNavigateToUpdatePageActionState) {
                      } else if (state is CalendarItemDeletedActionState) {
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
                          final successState =
                              state as CalendarLoadedSuccessState;
                          final List<Appointment> allEvents =
                              successState.appointments;
                          eventBloc.add(EventDaySelectEvent(
                              selectedDay: _focusedDay,
                              appointments: allEvents));
                          return AppointmentCalendar(
                            focusedDay: _focusedDay,
                            selectedDay: _selectedDay,
                            calendarFormat: _calendarFormat,
                            onDaySelected: (selectedDay, focusedDay) {
                              eventBloc.add(EventDaySelectEvent(
                                  selectedDay: selectedDay,
                                  appointments: allEvents));
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = selectedDay;
                              });
                            },
                            onPageChanged: (focusedDay) {
                              _focusedDay = focusedDay;
                            },
                            onFormatChanged: (format) {
                              if (_calendarFormat != format) {
                                setState(() {
                                  _calendarFormat = format;
                                });
                              }
                            },
                            eventLoader: isTrainer
                                ? (day) => allEvents
                                    .where(
                                        (event) => isSameDay(event.date, day))
                                    .toList()
                                : null,
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
                isTrainer
                    ? BlocConsumer<EventBloc, EventState>(
                        bloc: eventBloc,
                        listenWhen: (previous, current) =>
                            current is EventActionState,
                        buildWhen: (previous, current) =>
                            current is! EventActionState,
                        listener: (context, state) {
                          if (state is EventNavigateToUpdatePageActionState) {
                            if (!mounted) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    AppointmentFormDialog(
                                  focusedDay: state.focusedDay,
                                  appointment: state.appointment,
                                ),
                                fullscreenDialog: true,
                              ),
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
                              final successState =
                                  state as EventDaySelectedState;
                              final selectedEvents = [
                                ...successState.appointments
                              ]..sort(
                                  (a, b) => a.startTime.compareTo(b.startTime));
                              if (selectedEvents.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 24.0),
                                  child: Center(
                                    child: Text(
                                      'No appointments for this day.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ),
                                );
                              }

                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: selectedEvents.length,
                                itemBuilder: (context, index) {
                                  final Appointment appointmentModel =
                                      selectedEvents[index];
                                  final String title = _trainerNameById[
                                          appointmentModel.trainerId] ??
                                      'Trainer #${appointmentModel.trainerId}';
                                  return AppointmentEventTile(
                                    title: title,
                                    subtitle:
                                        "${appointmentModel.startTime} to ${appointmentModel.endTime}",
                                    onTap: () {
                                      if (!mounted) return;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              AppointmentDetailsPage(
                                            appointment: appointmentModel,
                                          ),
                                        ),
                                      );
                                    },
                                    onEdit: () {
                                      eventBloc.add(EventEditButtonClickedEvent(
                                          appointment: appointmentModel,
                                          focusedDay: _focusedDay));
                                    },
                                    onDelete: () {
                                      calendarBloc.add(
                                          CalendarDeleteButtonClicked(
                                              appointment: appointmentModel));
                                    },
                                  );
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
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

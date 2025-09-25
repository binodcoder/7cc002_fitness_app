import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:fitness_app/features/appointment/domain/entities/appointment.dart';
import 'package:fitness_app/drawer.dart';
import 'package:fitness_app/injection_container.dart';
import 'package:fitness_app/features/appointment/presentation/get_appointments/bloc/calender_bloc.dart';
import 'package:fitness_app/features/appointment/presentation/get_appointments/bloc/calender_event.dart';
import 'package:fitness_app/features/appointment/presentation/get_appointments/bloc/calender_state.dart';
import 'package:fitness_app/features/appointment/presentation/get_appointments/bloc/event_bloc.dart';
import 'package:fitness_app/features/appointment/presentation/get_appointments/bloc/event_event.dart';
import 'package:fitness_app/features/appointment/presentation/get_appointments/bloc/event_state.dart';
import 'package:fitness_app/features/appointment/presentation/get_appointments/ui/appointment_details.dart';
import 'package:fitness_app/features/appointment/presentation/get_appointments/widgets/appointment_event_tile.dart';
import 'package:fitness_app/features/appointment/presentation/get_appointments/widgets/appointment_calendar.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';

import '../../add_update_appointment/ui/add_appointment.dart';
import 'package:fitness_app/features/appointment/domain/usecases/sync.dart';
import 'package:fitness_app/features/appointment/domain/entities/sync.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  final CalenderBloc calenderBloc = sl<CalenderBloc>();
  final EventBloc eventBloc = sl<EventBloc>();
  final Sync _sync = sl<Sync>();

  @override
  void initState() {
    super.initState();
    calenderBloc.add(const CalenderInitialEvent());
    _loadTrainerMap();
  }

  void refreshPage() {
    calenderBloc.add(const CalenderInitialEvent());
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
    calenderBloc.close();
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
            calenderBloc
                .add(CalenderAddButtonClickedEvent(selectedDay: _focusedDay));
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
                BlocConsumer<CalenderBloc, CalenderState>(
                    bloc: calenderBloc,
                    listenWhen: (previous, current) =>
                        current is CalenderActionState,
                    buildWhen: (previous, current) =>
                        current is! CalenderActionState,
                    listener: (context, state) {
                      if (state is CalenderNavigateToAddCalenderActionState) {
                        if (!mounted) return;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                AddAppointmentDialog(
                                    focusedDay: state.focusedDay),
                            fullscreenDialog: true,
                          ),
                        ).then(
                          (value) => refreshPage(),
                        );
                      } else if (state
                          is CalenderNavigateToDetailPageActionState) {
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
                          is CalenderNavigateToUpdatePageActionState) {
                      } else if (state is CalenderItemDeletedActionState) {
                        calenderBloc.add(const CalenderInitialEvent());
                      } else if (state is CalenderItemsDeletedActionState) {
                      } else if (state is CalenderShowErrorActionState) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.message)),
                        );
                      }
                    },
                    builder: (context, state) {
                      switch (state.runtimeType) {
                        case CalenderLoadingState:
                          return const Center(
                            child: LinearProgressIndicator(),
                          );

                        case CalenderLoadedSuccessState:
                          final successState =
                              state as CalenderLoadedSuccessState;
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

                        case CalenderErrorState:
                          final error = state as CalenderErrorState;
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
                                    AddAppointmentDialog(
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
                                      calenderBloc.add(
                                          CalenderDeleteButtonClickedEvent(
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:fitness_app/core/model/appointment_model.dart';
import 'package:fitness_app/drawer.dart';
import 'package:fitness_app/injection_container.dart';
import 'package:fitness_app/features/appointment/presentation/appointment/get_appointments/bloc/calender_bloc.dart';
import 'package:fitness_app/features/appointment/presentation/appointment/get_appointments/bloc/calender_event.dart';
import 'package:fitness_app/features/appointment/presentation/appointment/get_appointments/bloc/calender_state.dart';
import 'package:fitness_app/features/appointment/presentation/appointment/get_appointments/bloc/event_bloc.dart';
import 'package:fitness_app/features/appointment/presentation/appointment/get_appointments/bloc/event_event.dart';
import 'package:fitness_app/features/appointment/presentation/appointment/get_appointments/bloc/event_state.dart';
import 'package:fitness_app/features/appointment/presentation/appointment/get_appointments/ui/appointment_details.dart';
import 'package:fitness_app/core/localization/app_strings.dart';
import 'package:fitness_app/core/theme/colour_manager.dart';

import '../../add_update_appointment/ui/add_appointment.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    calenderBloc.add(CalenderInitialEvent());
    super.initState();
  }

  void refreshPage() {
    calenderBloc.add(CalenderInitialEvent());
  }

  CalenderBloc calenderBloc = sl<CalenderBloc>();
  EventBloc eventBloc = sl<EventBloc>();
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  List<AppointmentModel> _selectedEvents = [];
  final SharedPreferences sharedPreferences = sl<SharedPreferences>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final strings = AppStrings.of(context);

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
            calenderBloc.add(CalenderAddButtonClickedEvent(_focusedDay));
          },
        ),
        appBar: AppBar(
          backgroundColor: ColorManager.primary,
          title: Text(strings.titleAppointmentLabel),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            BlocConsumer<CalenderBloc, CalenderState>(
                bloc: calenderBloc,
                listenWhen: (previous, current) =>
                    current is CalenderActionState,
                buildWhen: (previous, current) =>
                    current is! CalenderActionState,
                listener: (context, state) {
                  if (state is CalenderNavigateToAddCalenderActionState) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            AddAppointmentDialog(focusedDay: state.focusedDay),
                        fullscreenDialog: true,
                      ),
                    ).then(
                      (value) => refreshPage(),
                    );
                  } else if (state is CalenderNavigateToDetailPageActionState) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            AppointmentDetailsPage(
                          appointmentModel: state.appointmentModel,
                        ),
                        fullscreenDialog: true,
                      ),
                    ).then(
                      (value) => refreshPage(),
                    );
                  } else if (state is CalenderNavigateToUpdatePageActionState) {
                  } else if (state is CalenderItemDeletedActionState) {
                    calenderBloc.add(CalenderInitialEvent());
                  } else if (state is CalenderItemsDeletedActionState) {}
                },
                builder: (context, state) {
                  switch (state.runtimeType) {
                    case CalenderLoadingState:
                      return const Center(
                        child: LinearProgressIndicator(),
                      );

                    case CalenderLoadedSuccessState:
                      final successState = state as CalenderLoadedSuccessState;
                      final List<AppointmentModel> allEvents =
                          successState.appointmentModels;
                      eventBloc
                          .add(EventDaySelectEvent(_focusedDay, allEvents));
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: ColorManager.white,
                        ),
                        margin: EdgeInsets.all(size.width * 0.02),
                        child: TableCalendar(
                          firstDay: DateTime.utc(2010, 10, 16),
                          lastDay: DateTime.utc(2030, 3, 14),
                          focusedDay: _focusedDay,
                          selectedDayPredicate: (day) {
                            return isSameDay(_selectedDay, day);
                          },
                          onDaySelected: (selectedDay, focusedDay) {
                            eventBloc.add(
                                EventDaySelectEvent(selectedDay, allEvents));
                            _selectedDay = selectedDay;
                            _focusedDay = selectedDay;
                            setState(() {});
                          },
                          onPageChanged: (focusedDay) {
                            _focusedDay = focusedDay;
                          },
                          eventLoader: sharedPreferences.getString('role') ==
                                  "trainer"
                              ? (day) {
                                  return allEvents
                                      .where(
                                          (event) => isSameDay(event.date, day))
                                      .toList();
                                }
                              : null,
                          calendarFormat: _calendarFormat,
                          onFormatChanged: (format) {
                            if (_calendarFormat != format) {
                              setState(() {
                                _calendarFormat = format;
                              });
                            }
                          },
                          calendarStyle: const CalendarStyle(
                            selectedDecoration: BoxDecoration(
                              color: ColorManager.primary,
                              shape: BoxShape.circle,
                            ),
                            markerDecoration: BoxDecoration(
                              color: ColorManager.darkGrey,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      );

                    case CalenderErrorState:
                      return const Scaffold(body: Center(child: Text('Error')));
                    default:
                      return const SizedBox();
                  }
                }),
            sharedPreferences.getString('role') == "trainer"
                ? Expanded(
                    child: BlocConsumer<EventBloc, EventState>(
                      bloc: eventBloc,
                      listenWhen: (previous, current) =>
                          current is EventActionState,
                      buildWhen: (previous, current) =>
                          current is! EventActionState,
                      listener: (context, state) {
                        if (state is EventNavigateToUpdatePageActionState) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  AddAppointmentDialog(
                                focusedDay: state.focusedDay,
                                appointmentModel: state.appointmentModel,
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
                            final successState = state as EventDaySelectedState;
                            _selectedEvents = successState.appointmentModels;

                            return ListView.builder(
                              itemCount: _selectedEvents.length,
                              itemBuilder: (context, index) {
                                AppointmentModel appointmentModel =
                                    _selectedEvents[index];
                                String trainerName = "Binod Bhandari";
                                return Slidable(
                                  endActionPane: ActionPane(
                                    extentRatio: 0.46,
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) {
                                          eventBloc.add(
                                              EventEditButtonClickedEvent(
                                                  appointmentModel,
                                                  _focusedDay));
                                        },
                                        backgroundColor:
                                            const Color(0xFF21B7CA),
                                        foregroundColor: Colors.white,
                                        icon: Icons.edit,
                                        label: 'Edit',
                                      ),
                                      SlidableAction(
                                        onPressed: (context) {
                                          calenderBloc.add(
                                              CalenderDeleteButtonClickedEvent(
                                                  appointmentModel));
                                        },
                                        backgroundColor:
                                            const Color(0xFF21B7CA),
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                        label: 'Delete',
                                      )
                                    ],
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: ColorManager.white,
                                    ),
                                    margin: EdgeInsets.all(size.width * 0.02),
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                AppointmentDetailsPage(
                                              appointmentModel:
                                                  appointmentModel,
                                            ),
                                          ),
                                        );
                                      },
                                      title: Text(trainerName),
                                      subtitle: Text(
                                          "${appointmentModel.startTime} to ${appointmentModel.endTime}"),
                                    ),
                                  ),
                                );
                              },
                            );
                          case CalenderErrorState:
                            return const Scaffold(
                                body: Center(child: Text('Error')));
                          default:
                            return const SizedBox();
                        }
                      },
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

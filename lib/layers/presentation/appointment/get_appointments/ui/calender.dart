import 'package:fitness_app/core/model/appointment_model.dart';
import 'package:fitness_app/layers/presentation/appointment/get_appointments/bloc/calender_bloc.dart';
import 'package:fitness_app/layers/presentation/appointment/get_appointments/bloc/calender_event.dart';
import 'package:fitness_app/layers/presentation/appointment/get_appointments/bloc/calender_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../../injection_container.dart';
import '../../../../../resources/colour_manager.dart';
import '../../add_update_appointment/ui/add_appointment.dart';
import 'appointment_details.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  //late final ValueNotifier<List<AppointmentModel>> _selectedAppointments;
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
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  List<AppointmentModel> _selectedEvents = [];

  // Map<DateTime, List<AppointmentModel>> groupedEvents = {};
  //
  // addEventsToMap(CalenderLoadedSuccessState successState) {
  //   for (var event in successState.appointmentModels) {
  //     DateTime date = event.date;
  //     groupedEvents[date]?.add(event);
  //   }
  //   //  _selectedAppointments = ValueNotifier(getEventsForDay(_selectedDay, groupedEvents));
  // }

  // List<AppointmentModel> _getEventsForDay(DateTime day, var events) {
  //   return events[day] ?? [];
  // }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;

    return BlocConsumer<CalenderBloc, CalenderState>(
      bloc: calenderBloc,
      listenWhen: (previous, current) => current is CalenderActionState,
      buildWhen: (previous, current) => current is! CalenderActionState,
      listener: (context, state) {
        if (state is CalenderNavigateToAddCalenderActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const AddAppointmentDialog(),
              fullscreenDialog: true,
            ),
          );
        } else if (state is CalenderNavigateToDetailPageActionState) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => AppointmentDetailsPage(
                appointmentModel: state.appointmentModel,
              ),
              fullscreenDialog: true,
            ),
          ).then(
            (value) => refreshPage(),
          );
        } else if (state is CalenderNavigateToUpdatePageActionState) {
        } else if (state is CalenderItemSelectedActionState) {
        } else if (state is CalenderItemDeletedActionState) {
        } else if (state is CalenderItemsDeletedActionState) {}
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case CalenderLoadingState:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case CalenderLoadedSuccessState:
            final successState = state as CalenderLoadedSuccessState;
            _selectedEvents = state.appointmentModels;
            // _selectedAppointments = ValueNotifier(_selectedEvents);

            // addEventsToMap(successState);
            return SafeArea(
              child: Scaffold(
                floatingActionButton: FloatingActionButton(
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.add),
                  onPressed: () {
                    // postBloc.add(RoutineAddButtonClickedEvent());
                  },
                ),
                appBar: AppBar(
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: ColorManager.white,
                    ),
                    onPressed: () {},
                  ),
                  title: Text('appointment'),
                  centerTitle: true,
                ),
                body: Column(
                  children: <Widget>[
                    TableCalendar(
                      firstDay: DateTime.utc(2010, 10, 16),
                      lastDay: DateTime.utc(2030, 3, 14),
                      focusedDay: _focusedDay,
                      weekendDays: const [6],
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                          _selectedEvents = successState.appointmentModels.where((event) => isSameDay(event.date, selectedDay)).toList();
                          // _selectedAppointments = ValueNotifier(_selectedEvents);
                          print(_selectedEvents);
                        });
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },

                      eventLoader: (day) {
                        // Check if the 'day' matches the date of any event in your _events list
                        return successState.appointmentModels.where((event) => isSameDay(event.date, day)).toList();
                      },
                      // eventLoader: (day) {
                      //   return _getEventsForDay(day, groupedEvents);
                      // },
                      calendarFormat: _calendarFormat,
                      onFormatChanged: (format) {
                        if (_calendarFormat != format) {
                          // Call `setState()` when updating calendar format
                          setState(() {
                            _calendarFormat = format;
                          });
                        }
                      },

                      headerStyle: HeaderStyle(
                        headerPadding: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        headerMargin: const EdgeInsets.only(bottom: 8.0),
                        titleTextStyle: TextStyle(color: Colors.blueGrey[900]),
                        formatButtonDecoration: BoxDecoration(
                          color: Colors.blue[100],
                          // border: Border.all(color: Colors.blueGrey[900]),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        formatButtonTextStyle: TextStyle(color: Colors.blueGrey[900]),
                        leftChevronIcon: Icon(
                          Icons.chevron_left,
                          color: Colors.blueGrey[900],
                        ),
                      ),
                      calendarStyle: const CalendarStyle(),
                    ),

                    Expanded(
                      child: ListView.builder(
                        itemCount: _selectedEvents.length,
                        itemBuilder: (context, index) {
                          var appointmentModel = _selectedEvents[index];
                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => AppointmentDetailsPage(
                                    appointmentModel: appointmentModel,
                                  ),
                                ),
                              );
                            },
                            title: Text(appointmentModel.startTime),
                            subtitle: Text(appointmentModel.endTime),
                          );
                        },
                      ),
                    ),

                    // ValueListenableBuilder(
                    //     valueListenable: _selectedAppointments,
                    //     builder: (context, value, _) {
                    //       return ListView.builder(itemBuilder: (context, index) {
                    //         return Text(value[index].startTime);
                    //       });
                    //     }),
                  ],
                ),
              ),
            );
          case CalenderErrorState:
            return const Scaffold(body: Center(child: Text('Error')));
          default:
            return const SizedBox();
        }
      },
    );
  }
}

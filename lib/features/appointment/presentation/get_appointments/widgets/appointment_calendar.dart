import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:fitness_app/core/theme/colour_manager.dart';

class AppointmentCalendar extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final CalendarFormat calendarFormat;
  final void Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;
  final void Function(DateTime focusedDay) onPageChanged;
  final void Function(CalendarFormat format) onFormatChanged;
  final List<dynamic> Function(DateTime day)? eventLoader;

  const AppointmentCalendar({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.calendarFormat,
    required this.onDaySelected,
    required this.onPageChanged,
    required this.onFormatChanged,
    required this.eventLoader,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorManager.white,
      ),
      margin: EdgeInsets.all(size.width * 0.02),
      child: TableCalendar(
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        focusedDay: focusedDay,
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        onDaySelected: onDaySelected,
        onPageChanged: onPageChanged,
        eventLoader: eventLoader,
        calendarFormat: calendarFormat,
        onFormatChanged: onFormatChanged,
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
  }
}


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
    final scheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: ColorManager.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      margin: EdgeInsets.all(size.width * 0.03),
      child: TableCalendar(
        // Range kept generous to cover most realistic use-cases
        firstDay: DateTime.utc(2010, 1, 1),
        lastDay: DateTime.utc(2035, 12, 31),
        focusedDay: focusedDay,
        selectedDayPredicate: (day) => isSameDay(selectedDay, day),
        onDaySelected: onDaySelected,
        onPageChanged: onPageChanged,
        eventLoader: eventLoader,
        calendarFormat: calendarFormat,
        onFormatChanged: onFormatChanged,
        startingDayOfWeek: StartingDayOfWeek.monday,
        availableGestures: AvailableGestures.all,
        pageAnimationEnabled: true,
        rowHeight: 46,
        headerStyle: HeaderStyle(
          titleCentered: true,
          formatButtonVisible: true,
          titleTextStyle: Theme.of(context).textTheme.titleMedium!,
          leftChevronIcon: Icon(Icons.chevron_left, color: scheme.onSurface),
          rightChevronIcon: Icon(Icons.chevron_right, color: scheme.onSurface),
          formatButtonTextStyle: Theme.of(context)
              .textTheme
              .labelLarge!
              .copyWith(color: Colors.white),
          formatButtonDecoration: BoxDecoration(
            color: scheme.primary,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: Theme.of(context).textTheme.bodySmall!,
          weekendStyle: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: scheme.error),
        ),
        calendarStyle: CalendarStyle(
          isTodayHighlighted: true,
          todayDecoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: scheme.primary, width: 1.5),
          ),
          todayTextStyle: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: scheme.primary),
          selectedDecoration: const BoxDecoration(
            color: ColorManager.primary,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Colors.white),
          markerDecoration: BoxDecoration(
            color: scheme.secondary,
            shape: BoxShape.circle,
          ),
          outsideDaysVisible: false,
          weekendTextStyle: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: scheme.error),
        ),
        calendarBuilders: CalendarBuilders(
          // Show a compact counter pill for events
          markerBuilder: (context, day, events) {
            if (events.isEmpty) return const SizedBox.shrink();
            return Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                margin: const EdgeInsets.only(right: 2, bottom: 2),
                decoration: BoxDecoration(
                  color: scheme.secondary.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${events.length}',
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(color: Colors.white),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

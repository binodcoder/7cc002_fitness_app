import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../resources/colour_manager.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Size size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
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
        body: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            Card(
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.all(8.0),
              child: TableCalendar(
                focusedDay: DateTime.now(),
                firstDay: DateTime.now(),
                lastDay: DateTime.now(),
                weekendDays: const [6],
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
            ),
          ]),
        ),
      ),
    );
  }
}

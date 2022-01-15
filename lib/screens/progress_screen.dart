import 'package:flutter/material.dart';
import 'package:ripeto_flutter/component.dart';
import 'package:table_calendar/table_calendar.dart';

class ProgressScreen extends StatefulWidget {
  static const String id = 'progress_screen';

  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            progressScreenHeader(),
            Padding(
              padding: EdgeInsets.all(30.0),
              child: TableCalendar(
                firstDay: DateTime.utc(2022, 1, 1),
                lastDay: DateTime.utc(2022, 1, 21),
                focusedDay: focusedDay,
                onPageChanged: (daySelected) {
                  setState(() {
                    focusedDay = daySelected;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding progressScreenHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            mainScreenTitle('Progress'),
          ],
        ),
      ),
    );
  }
}

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
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(30.0),
                      child: TableCalendar(
                        firstDay: DateTime.utc(2020),
                        lastDay: DateTime.utc(2025),
                        focusedDay: focusedDay,
                        onPageChanged: (daySelected) {
                          setState(() {
                            focusedDay = daySelected;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: streakCard(5),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Divider(
              height: 0.0,
              thickness: 1.0,
            ),
          ],
        ),
      ),
    );
  }

  Padding streakCard(int day) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Text(
          day.toString() + ' Day(s) Streak',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
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

import 'dart:collection';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ripeto_flutter/component.dart';
import 'package:ripeto_flutter/service/notification_api.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:table_calendar/table_calendar.dart';

class ProgressScreen extends StatefulWidget {
  static const String id = 'progress_screen';

  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  User loggedInUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print('Get current user successful');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            progressScreenHeader(),
            Expanded(
              child: Column(
                children: [
                  sfCalendar(),
                  Divider(
                    height: 0.0,
                    thickness: 1.0,
                  ),
                  streakCardList(5),
                ],
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

  StreamBuilder streakCardList(int day) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('userData')
          .doc(loggedInUser.uid)
          .collection('habit')
          .snapshots(),
      builder: (context, snapshot) {
        final habitQueryList = snapshot.data.docs;
        List<Widget> allStreakCard = [
          SizedBox(height: 20.0),
        ]; //Sized box before the first habit card.

        for (int i = 0; i < habitQueryList.length; i++) {
          var streak = habitQueryList[i];
          allStreakCard.add(
            streakCard(streak),
          );
          allStreakCard.add(
            SizedBox(height: 20.0),
          );
          print('Streak card ' +
              streak.get('habit_name') +
              ' generation successful.');
        }

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: allStreakCard,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget streakCard(QueryDocumentSnapshot streak) {
    return StreamBuilder<QuerySnapshot>(
        stream: streak.reference.collection('history').snapshots(),
        builder: (context, snapshot) {
          int randomInt2To9 = Random().nextInt(8) + 2;
          int greenShade = randomInt2To9 * 100;

          if (streak.get('habit_name') == 'Jogging')
            randomInt2To9 = 2;
          else
            randomInt2To9 = 1;

          var historyQueryList = snapshot.data.docs;

          List<DateTime> historyDateTimeList =
              convertQueryListToDateTimeList(historyQueryList);

          DateTime earliestDateTime = findEarliestDateTime(historyDateTimeList);

          for (int i = 0; i < historyQueryList.length; i++) {
            var history = historyQueryList[i];

            history.get('timestamp');
          }

          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.green[greenShade],
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    streak.get(habitNameKey),
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    randomInt2To9.toString() + ' Streak',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Padding sfCalendar() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: SfCalendar(
        firstDayOfWeek: 1,
        view: CalendarView.week,
        dataSource: MeetingDataSource(getAppointment()),
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

List<Appointment> getAppointment() {
  List<Appointment> meetings = <Appointment>[];

  final DateTime now = DateTime.now();
  // final DateTime jogging = DateTime(now.year,now.minute)
  final DateTime startTime = DateTime(now.year, now.month, now.day, 6, 50, 0);

  final DateTime endTime = startTime.add(Duration(hours: 1));

  meetings.add(Appointment(
    startTime: DateTime(2022, 1, 31, 6, 50),
    endTime: DateTime(2022, 1, 31, 6, 50).add(Duration(hours: 2)),
    subject: 'Jogging after Subuh Prayer',
    color: Colors.green,
  ));

  meetings.add(Appointment(
    startTime: DateTime(2022, 2, 1, 6, 50),
    endTime: DateTime(2022, 2, 1, 6, 50).add(Duration(hours: 2)),
    subject: 'Jogging after Subuh Prayer',
    color: Colors.grey,
  ));

  meetings.add(Appointment(
    startTime: DateTime(2022, 1, 24, 6, 50),
    endTime: DateTime(2022, 1, 24, 6, 50).add(Duration(hours: 2)),
    subject: 'Jogging after Subuh Prayer',
    color: Colors.redAccent,

    // recurrenceRule: 'FREQ=WEEKLY;COUNT=10',
  ));

  meetings.add(Appointment(
    startTime: DateTime(2022, 1, 25, 6, 50),
    endTime: DateTime(2022, 1, 25, 6, 50).add(Duration(hours: 2)),
    subject: 'Jogging after Subuh Prayer',
    color: Colors.green,

    // recurrenceRule: 'FREQ=WEEKLY;COUNT=10',
  ));

  meetings.add(Appointment(
    startTime: DateTime(2022, 1, 28, 17, 30),
    endTime: DateTime(2022, 1, 28, 17, 30).add(Duration(hours: 2)),
    subject: 'Reading book After work',
    color: Colors.green,
  ));

  meetings.add(Appointment(
    startTime: DateTime(2022, 2, 4, 17, 30),
    endTime: DateTime(2022, 2, 4, 17, 30).add(Duration(hours: 2)),
    subject: 'Reading book After work',
    color: Colors.grey,
  ));

  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}

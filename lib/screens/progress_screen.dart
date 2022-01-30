import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ripeto_flutter/component.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:table_calendar/table_calendar.dart';

class ProgressScreen extends StatefulWidget {
  static const String id = 'progress_screen';

  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  DateTime _focusedDay = DateTime.now();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  User loggedInUser;
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    _events = {};
    _selectedEvents = [];
  }

  Widget eventCard = Container();
  Padding predefinedEventCard = Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Text(
            'try',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ),
  );

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
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    // progressCalendar(),
                    sfCalendar(),
                    eventCard,
                    streakCard(5),
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

  StreamBuilder streakCard(int day) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('userData')
          .doc(loggedInUser.uid)
          .collection('habit')
          .snapshots(),
      builder: (context, snapshot) {
        //TODO: If snapshot has data, continue here.
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Text(
                  day.toString() + ' Days Streak',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Padding progressCalendar() {
    return Padding(
      padding: EdgeInsets.all(30.0),
      child: TableCalendar(
          firstDay: DateTime.utc(2020),
          lastDay: DateTime.utc(2025),
          focusedDay: _focusedDay,
          onPageChanged: (daySelected) {
            setState(() {
              _focusedDay = daySelected;
            });
          },
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          eventLoader: (day) {
            if (day.weekday == DateTime.saturday ||
                day.weekday == DateTime.sunday) {
              eventCard = predefinedEventCard;
              return ['test'];
            } else
              return null;
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay; // update `_focusedDay` here as well
              // _selectedEvents = _events;
            });
          }),
    );
  }

  Padding sfCalendar() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: SfCalendar(
        view: CalendarView.week,
        dataSource: MeetingDataSource(getAppointment()),
      ),
    );
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _focusedDay = focusedDay;
        _selectedDay = selectedDay;
        _selectedEvents = _getEventsForDay(selectedDay);
      });
    }
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
  final DateTime startTime = DateTime(now.year, now.month, now.day, 9, 0, 0);

  final DateTime endTime = startTime.add(Duration(hours: 1));

  meetings.add(Appointment(
    startTime: startTime,
    endTime: endTime,
    subject: 'Jogging after breakfast',
    color: Colors.grey,
  ));
  meetings.add(Appointment(
    startTime: startTime.subtract(Duration(days: 6)),
    endTime: startTime.subtract(Duration(days: 6)).add(Duration(hours: 1)),
    subject: 'Reading book after breakfast',
    color: Colors.green,
  ));

  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}

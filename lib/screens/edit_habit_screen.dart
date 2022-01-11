import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_picker/day_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ripeto_flutter/component.dart';

class EditHabitScreen extends StatefulWidget {
  static const String id = 'edit_habit_screen';

  @override
  _EditHabitScreenState createState() => _EditHabitScreenState();
}

class _EditHabitScreenState extends State<EditHabitScreen> {
  bool showSpinner = false;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String habitName;
  String triggerEvent;
  String reminderTimeString;
  String frequencyString;

  DateTime dateTimeNow = DateTime.now();

  List<DayInWeek> dayList = [
    DayInWeek(
      "Sun",
    ),
    DayInWeek(
      "Mon",
    ),
    DayInWeek(
      "Tue",
    ),
    DayInWeek(
      "Wed",
    ),
    DayInWeek(
      "Thu",
    ),
    DayInWeek(
      "Fri",
    ),
    DayInWeek(
      "Sat",
    ),
  ];

  TimeOfDay convertStringToTimeOfDay(String timeOfDayString) {
    return TimeOfDay(
      hour: int.parse(timeOfDayString.substring(
          10, 12)), //Substring from hour in "TimeOfDay(XX:00)"
      minute: int.parse(timeOfDayString.substring(
          13, 15)), //Substring from minute in "TimeOfDay(00:XX)"
    );
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context).settings.arguments as Map;

    if (arguments != null) print(arguments);

    String uid = arguments['uid'];
    String habitId = arguments[habitIdKey];
    habitName = arguments[habitNameKey];
    triggerEvent = arguments[triggerEventKey];
    reminderTimeString = arguments[reminderTimeKey];
    frequencyString = arguments[frequencyKey];

    TimeOfDay reminderTime = convertStringToTimeOfDay(reminderTimeString);

    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(50.0),
            child: Column(
              children: [
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  'Edit Habit',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                RipetoTextField(
                  initialValue: habitName,
                  onChanged: (value) {
                    habitName = value;
                  },
                  labelText: 'Habit Name',
                ),
                SizedBox(
                  height: 20.0,
                ),
                RipetoTextField(
                  initialValue: triggerEvent,
                  onChanged: (value) {
                    triggerEvent = value;
                  },
                  labelText: 'Trigger Event',
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text('Choose Time'),
                Container(
                  height: 40.0,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.time,
                    onDateTimeChanged: (value) {
                      reminderTimeString =
                          TimeOfDay.fromDateTime(value).toString();
                      print(reminderTimeString);
                    },
                    initialDateTime: DateTime(
                      dateTimeNow.year,
                      dateTimeNow.month,
                      dateTimeNow.day,
                      reminderTime.hour,
                      reminderTime.minute,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text('Frequency'),
                SizedBox(
                  height: 20.0,
                ),
                SelectWeekDays(
                  fontSize: 10.0,
                  boxDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.blue,
                  ),
                  onSelect: (value) {
                    frequencyString = value.toString();
                    print(value);
                  },
                  days: dayList,
                ),
                SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      // final uid = _auth.currentUser.uid;
                      //TODO: Refactor this. Study about state management.
                      await _firestore
                          .collection('userData')
                          .doc(uid)
                          .collection('habit')
                          .doc(habitId)
                          .update(
                        {
                          'habit_name': habitName,
                          'trigger_event': triggerEvent,
                          'reminder_time': reminderTimeString,
                          'frequency': frequencyString
                        },
                      );
                      showSpinner = false;
                      Navigator.pop(context);
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Text('Edit'),
                  style: ButtonStyle(),
                ),
                SizedBox(
                  height: 100.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

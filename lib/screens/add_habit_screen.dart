import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_picker/day_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ripeto_flutter/component.dart';
import 'package:uuid/uuid.dart';
import 'package:weekday_selector/weekday_selector.dart';

class AddHabitScreen extends StatefulWidget {
  static const String id = 'add_habit_screen';

  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  String habitName;
  String triggerEvent;
  String reminderTime = TimeOfDay.now().toString();

  bool showSpinner = false;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  List<bool> frequency = List.filled(7, false);

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

  @override
  Widget build(BuildContext context) {
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
                  'Add Habit',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                RipetoTextField(
                  onChanged: (value) {
                    habitName = value;
                  },
                  labelText: 'Habit Name',
                ),
                SizedBox(
                  height: 20.0,
                ),
                RipetoTextField(
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
                      reminderTime = TimeOfDay.fromDateTime(value).toString();
                      print(reminderTime);
                    },
                    initialDateTime: DateTime.now(),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text('Frequency'),
                SizedBox(
                  height: 20.0,
                ),
                WeekdaySelector(
                  onChanged: (int day) {
                    setState(() {
                      // Use module % 7 as Sunday's index in the array is 0 and
                      // DateTime.sunday constant integer value is 7.
                      final index = day % 7;
                      // We "flip" the value in this example, but you may also
                      // perform validation, a DB write, an HTTP call or anything
                      // else before you actually flip the value,
                      // it's up to your app's needs.
                      frequency[index] = !frequency[index];
                      print(frequency);
                    });
                  },
                  values: frequency,
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
                      final uid = _auth.currentUser.uid;
                      //TODO: Refactor this. Study about state management.
                      await _firestore
                          .collection('userData')
                          .doc(uid)
                          .collection('habit')
                          .add({
                        //TODO: create random id with uuid package.
                        habitNameKey: habitName,
                        triggerEventKey: triggerEvent,
                        reminderTimeKey: reminderTime,
                        frequencyKey: frequency.toString()
                      });
                      showSpinner = false;
                      Navigator.pop(context);
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Text('Add'),
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

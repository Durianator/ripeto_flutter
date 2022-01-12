import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_picker/day_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ripeto_flutter/component.dart';
import 'package:weekday_selector/weekday_selector.dart';

class EditHabitScreen extends StatefulWidget {
  static const String id = 'edit_habit_screen';

  const EditHabitScreen(this.habitMap);

  final Map<String, String> habitMap;

  @override
  _EditHabitScreenState createState() => _EditHabitScreenState(habitMap);
}

class _EditHabitScreenState extends State<EditHabitScreen> {
  Map<String, String> habitMap;

  _EditHabitScreenState(this.habitMap);

  bool showSpinner = false;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String uid;
  String habitId;
  String habitName;
  String triggerEvent;
  String reminderTimeString;
  String frequencyString;
  TimeOfDay reminderTime;
  List<bool> frequency;

  DateTime dateTimeNow = DateTime.now();

  @override
  void initState() {
    uid = habitMap['uid'];
    habitId = habitMap[habitIdKey];
    habitName = habitMap[habitNameKey];
    triggerEvent = habitMap[triggerEventKey];
    reminderTimeString = habitMap[reminderTimeKey];
    frequencyString = habitMap[frequencyKey];

    reminderTime = convertStringToTimeOfDay(reminderTimeString);
    frequency = convertStringFromFirebaseToBoolList(frequencyString);
    print(frequency);

    super.initState();
  }

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
    // if (habitMap != null) print(habitMap);
    //
    // String uid = habitMap['uid'];
    // String habitId = habitMap[habitIdKey];
    // habitName = habitMap[habitNameKey];
    // triggerEvent = habitMap[triggerEventKey];
    // reminderTimeString = habitMap[reminderTimeKey];
    // frequencyString = habitMap[frequencyKey];
    //
    // TimeOfDay reminderTime = convertStringToTimeOfDay(reminderTimeString);
    // List<bool> frequency = convertStringFromFirebaseToBoolList(frequencyString);
    // print(frequency);

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
                      // final uid = _auth.currentUser.uid;
                      //TODO: Refactor this.
                      await _firestore
                          .collection('userData')
                          .doc(uid)
                          .collection('habit')
                          .doc(habitId)
                          .update(
                        {
                          habitNameKey: habitName,
                          triggerEventKey: triggerEvent,
                          reminderTimeKey: reminderTimeString,
                          frequencyKey: frequency.toString()
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

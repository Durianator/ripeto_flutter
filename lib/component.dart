import 'package:day_picker/day_picker.dart';
import 'package:flutter/material.dart';

const String habitNameKey = 'habit_name';
const String triggerEventKey = 'trigger_event';
const String reminderTimeKey = 'reminder_time';
const String frequencyKey = 'frequency';
const String habitIdKey = 'habit_id';

List<String> dayList = [
  'Sunday',
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
];

class RipetoTextField extends StatelessWidget {
  RipetoTextField(
      {@required this.onChanged,
      @required this.labelText,
      this.isEmail = false,
      this.obscureText = false,
      this.initialValue = ''});

  final Function(String) onChanged;
  final bool obscureText;
  final String labelText;
  final bool isEmail;
  final String initialValue;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: TextEditingController(text: initialValue),
      onChanged: onChanged,
      obscureText: obscureText,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: labelText,
      ),
    );
  }
}

Text mainScreenTitle(String title) {
  return Text(
    title,
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 25,
    ),
  );
}

List<bool> convertFrequencyFromFirebaseToBoolList(String boolListFromFirebase) {
  String boolListFromFirebaseCropped = boolListFromFirebase.substring(1,
      boolListFromFirebase.length - 1); //This line of code removes '[' and ']'.

  List boolListString = boolListFromFirebaseCropped.split(',');

  List<bool> boolList = [];

  boolListString.forEach((element) {
    if (element.toString().contains('true'))
      boolList.add(true);
    else
      boolList.add(false);
  });

  return boolList;
}

String convertReminderTimeFirebaseToReminderTimeString(
    String firebaseReminderTime) {
  return firebaseReminderTime.substring(
      10, 15); //Extract XX:XX from "TimeOfDay(XX:XX)".
}

List<String> convertFrequencyFirebaseDataToDayList(String firebaseFrequency) {
  List<bool> boolDayList =
      convertFrequencyFromFirebaseToBoolList(firebaseFrequency);
  List<String> trueDayList = [];

  for (var i = 0; i < boolDayList.length; i++) {
    if (boolDayList[i]) {
      trueDayList.add(dayList[i]);
    }
  }

  return trueDayList;
}

Widget buildChipForHabitCard(String firebaseFrequency) {
  List<bool> boolDayList =
      convertFrequencyFromFirebaseToBoolList(firebaseFrequency);
  List<Widget> dayChipList = [];

  for (var i = 0; i < boolDayList.length; i++) {
    if (boolDayList[i]) {
      dayChipList.add(
        Chip(
          label: Text(dayList[i]),
        ),
      );
    }
  }

  return Wrap(
    spacing: 10.0,
    children: dayChipList,
  );
}

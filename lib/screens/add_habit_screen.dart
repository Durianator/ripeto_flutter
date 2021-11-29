import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ripeto_flutter/component.dart';

class AddHabitScreen extends StatefulWidget {
  static const String id = 'add_habit_screen';

  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  String habitName;
  String triggerEvent;
  String reminderTime;
  String frequency;

  bool showSpinner = false;

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

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
                RipetoTextField(
                  onChanged: (value) {
                    reminderTime = value;
                  },
                  labelText: 'Reminder Time',
                ),
                SizedBox(
                  height: 20.0,
                ),
                RipetoTextField(
                  onChanged: (value) {
                    frequency = value;
                  },
                  labelText: 'Frequency',
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
                      await _db
                          .collection('userData')
                          .doc(uid)
                          .collection('habit')
                          .add({
                        'habit_name': habitName,
                        'trigger_event': triggerEvent,
                        'reminder_time': reminderTime,
                        'frequency': frequency
                      });
                      showSpinner = false;
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Text('Register'),
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

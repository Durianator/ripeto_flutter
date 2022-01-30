import 'package:flutter/material.dart';
import 'package:ripeto_flutter/component.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const String id = 'change_password_screen';
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            SizedBox(
              height: 30.0,
            ),
            Text(
              'Change Password',
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
                // habitName = value;
              },
              labelText: 'Current Password',
              obscureText: true,
            ),
            SizedBox(
              height: 20.0,
            ),
            RipetoTextField(
              onChanged: (value) {
                // triggerEvent = value;
              },
              labelText: 'New Password',
              obscureText: true,
            ),
            SizedBox(
              height: 20.0,
            ),
            //TODO: Code this if have time.
            // RipetoTextField(
            //   onChanged: (value) {
            //     // habitName = value;
            //   },
            //   labelText: 'Repeat Password',
            // ),
            // SizedBox(
            //   height: 20.0,
            // ),
            ElevatedButton(
              onPressed: () async {
                // setState(() {
                //   showSpinner = true;
                // });
                // try {
                //   final uid = _auth.currentUser.uid;
                //   //TODO: Refactor this.
                //   await _firestore
                //       .collection('userData')
                //       .doc(uid)
                //       .collection('habit')
                //       .add({
                //     habitNameKey: habitName,
                //     triggerEventKey: triggerEvent,
                //     reminderTimeKey: reminderTime,
                //     frequencyKey: frequency.toString()
                //   });
                //   showSpinner = false;
                //   Navigator.pop(context);
                // } catch (e) {
                //   print(e);
                // }
              },
              child: Text('Confirm'),
              style: ButtonStyle(),
            ),
          ],
        ),
      ),
    ));
  }

  Padding changePasswordScreenHeader() {
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

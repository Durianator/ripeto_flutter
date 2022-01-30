import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:ripeto_flutter/component.dart';
import 'package:ripeto_flutter/screens/change_password_screen.dart';

class UpdateProfileScreen extends StatefulWidget {
  static const String id = 'update_profile_screen';
  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
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
              'Update Profile',
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
              labelText: 'Email Address',
            ),
            SizedBox(
              height: 20.0,
            ),
            RipetoTextField(
              onChanged: (value) {
                // triggerEvent = value;
              },
              labelText: 'Name',
            ),
            SizedBox(
              height: 20.0,
            ),
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
            SizedBox(
              height: 20.0,
            ),
            TextButton(
              child: Text('Change Password'),
              onPressed: () {
                pushNewScreen(
                  context,
                  screen: ChangePasswordScreen(),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
            ),
          ],
        ),
      ),
    ));
  }
}

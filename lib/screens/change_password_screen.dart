import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ripeto_flutter/component.dart';
import 'package:ripeto_flutter/screens/real_home_screen.dart';
import 'package:ripeto_flutter/screens/settings_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  static const String id = 'change_password_screen';
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  String currentPassword;
  String newPassword;

  @override
  void initState() {
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

  void reauthenticateAuth() async {
    loggedInUser.reauthenticateWithCredential(
      EmailAuthProvider.credential(
        email: loggedInUser.email,
        password: currentPassword,
      ),
    );
  }

  void updatePassword() async {
    loggedInUser.updatePassword(newPassword);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Padding(
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
                  currentPassword = value;
                },
                labelText: 'Current Password',
                obscureText: true,
              ),
              SizedBox(
                height: 20.0,
              ),
              RipetoTextField(
                onChanged: (value) {
                  newPassword = value;
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
                  reauthenticateAuth();
                  updatePassword();
                  Navigator.pop(context);
                },
                child: Text('Confirm'),
                style: ButtonStyle(),
              ),
            ],
          ),
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

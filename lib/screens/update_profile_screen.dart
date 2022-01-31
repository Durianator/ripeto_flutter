import 'package:firebase_auth/firebase_auth.dart';
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
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  String newEmailAddress;
  String password;

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
          email: loggedInUser.email, password: password),
    );
  }

  void updateEmail() async {
    loggedInUser.updateEmail(newEmailAddress);
  }

  @override
  void initState() {
    super.initState();

    getCurrentUser();
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
                'Change Email',
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
                  newEmailAddress = value;
                },
                labelText: 'New Email Address',
              ),
              SizedBox(
                height: 20.0,
              ),
              RipetoTextField(
                onChanged: (value) {
                  password = value;
                },
                obscureText: true,
                labelText: 'Password',
              ),
              SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                onPressed: () async {
                  reauthenticateAuth();
                  updateEmail();
                  Navigator.pop(context);
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
      ),
    ));
  }
}

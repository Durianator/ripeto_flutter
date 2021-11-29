import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ripeto_flutter/component.dart';
import 'package:ripeto_flutter/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:ripeto_flutter/screens/sign_up_screen.dart';
import 'package:ripeto_flutter/component.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;

  bool showSpinner = false;

  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 100.0,
                  ),
                  Text(
                    'Ripeto',
                    style: TextStyle(fontSize: 50.0),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    'Habit Formation App',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  RipetoTextField(
                    isEmail: true,
                    onChanged: (value) {
                      email = value;
                    },
                    labelText: 'Email',
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
                    height: 30.0,
                  ),
                  ElevatedButton(
                    child: Text('Login'),
                    style: ButtonStyle(),
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        final user = await _auth.signInWithEmailAndPassword(
                            email: email, password: password);

                        if (user != null) {
                          Navigator.pushNamed(context, HomeScreen.id);
                        }
                        setState(() {
                          showSpinner = false;
                        });
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                  // SizedBox(
                  //   height: 30.0,
                  // ),
                  // SignInButton(Buttons.Google, onPressed: () {
                  //   try {
                  //     final user = googleSignIn.signIn();
                  //     if (user != null) {
                  //       Navigator.pushNamed(context, HomeScreen.id);
                  //     }
                  //   } catch (e) {
                  //     print(e);
                  //   }
                  // }),
                  SizedBox(
                    height: 20.0,
                  ),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Text(
                          'Create a new account',
                          style: TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        SignUpScreen.id,
                      );
                    },
                  ),
                  SizedBox(
                    height: 100.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

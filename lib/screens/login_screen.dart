import 'package:flutter/material.dart';
import 'package:ripeto_flutter/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email;
  String password;

  bool _initialized = false;
  bool _error = false;

  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();
  }

  // void initializeFlutterFire() async {
  //   try {
  //     await Firebase.initializeApp();
  //     setState(() {
  //       _initialized = true;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _error = true;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.0),
            child: Column(
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
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                TextField(
                  onChanged: (value) {
                    email = value;
                  },
                  autofocus: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  onChanged: (value) {
                    password = value;
                  },
                  autofocus: true,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    try {
                      final user = googleSignIn.signIn();

                      if (user != null) {
                        Navigator.pushNamed(context, HomeScreen.id);
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Text('Login'),
                  style: ButtonStyle(),
                ),
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
                      HomeScreen.id,
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
    );
  }
}

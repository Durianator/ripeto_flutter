import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ripeto_flutter/screens/add_habit_screen.dart';
import 'package:ripeto_flutter/screens/edit_habit_screen.dart';
import 'package:ripeto_flutter/screens/home_screen.dart';
import 'package:ripeto_flutter/screens/login_screen.dart';
import 'package:ripeto_flutter/screens/progress_screen.dart';
import 'package:ripeto_flutter/screens/real_home_screen.dart';
import 'package:ripeto_flutter/screens/settings_screen.dart';
import 'package:ripeto_flutter/screens/sign_up_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ripeto_flutter/service/notification_api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().init();
  tz.initializeTimeZones();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ripeto',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: Colors.blue,
      ),
      initialRoute: LoginScreen.id,
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        SignUpScreen.id: (context) => SignUpScreen(),
        AddHabitScreen.id: (context) => AddHabitScreen(),
        RealHomeScreen.id: (context) => RealHomeScreen(),
        ProgressScreen.id: (context) => ProgressScreen(),
        SettingsScreen.id: (context) => SettingsScreen(),
        // EditHabitScreen.id: (context) => EditHabitScreen(),
      },
    );
  }
}

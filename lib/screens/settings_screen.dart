import 'package:flutter/material.dart';
import 'package:ripeto_flutter/component.dart';
import 'package:ripeto_flutter/screens/home_screen.dart';

class SettingsScreen extends StatefulWidget {
  static const String id = 'settings_screen';
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            settingsScreenHeader(),
            Divider(),
            settingsOption(
              'Notification Setting',
              () {
                Navigator.pushNamed(context, HomeScreen.id);
              },
            ),
            Divider(),
            settingsOption(
              'Update Profile',
              () {
                Navigator.pushNamed(context, HomeScreen.id);
              },
            ),
            Divider(),
            settingsOption(
              'Logout',
              () {
                // await _auth.signOut();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  InkWell settingsOption(String settingsName, Function onTap) {
    return InkWell(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(
          vertical: 5.0,
          horizontal: 15.0,
        ),
        child: Text(
          settingsName,
          style: TextStyle(
            fontSize: 15.0,
          ),
        ),
      ),
      onTap: onTap,
    );
  }

  Padding settingsScreenHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            mainScreenTitle('Settings'),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}

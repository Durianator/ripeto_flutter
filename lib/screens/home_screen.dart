import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:ripeto_flutter/component.dart';
import 'package:ripeto_flutter/screens/add_habit_screen.dart';
import 'package:ripeto_flutter/screens/edit_habit_screen.dart';
import 'package:ripeto_flutter/screens/login_screen.dart';
import 'package:ripeto_flutter/screens/real_home_screen.dart';
import 'package:ripeto_flutter/service/notification_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  User loggedInUser;
  SharedPreferences prefs;

  final _firestore = FirebaseFirestore.instance;

  bool showSpinner = false;

  void storeUid() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('uid', loggedInUser.uid);
    print(prefs.getString('uid'));
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    storeUid();
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

  void deleteHabit(habitId) async {
    _firestore
        .collection('userData')
        .doc(loggedInUser.uid)
        .collection('habit')
        .doc(habitId)
        .delete();
  }

  void checkOffHabit(String habitId) async {
    setState(() {
      showSpinner = true;
    });
    try {
      final uid = _auth.currentUser.uid;
      //TODO: Add check off habit feature.
      await _firestore
          .collection('userData')
          .doc(uid)
          .collection('habit')
          .doc(habitId)
          .collection('history')
          .add({'timestamp': DateTime.now()});

      setState(() {
        showSpinner = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Column(
            children: [
              homeScreenHeader(context),
              Divider(
                height: 0.0,
                thickness: 1.0,
              ),
              homeScreenBody(),
              Divider(
                height: 0.0,
                thickness: 1.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding homeScreenHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 20.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          mainScreenTitle('Habit List'),
          ElevatedButton(
            onPressed: () {
              pushNewScreen(
                context,
                screen: AddHabitScreen(),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
              // Navigator.pushNamed(context, AddHabitScreen.id);
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  Expanded homeScreenBody() {
    return Expanded(
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 30.0,
          ),
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('userData')
                .doc(loggedInUser.uid)
                .collection('habit')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final habitQueryList = snapshot.data.docs;
                List<Widget> allHabitCard = [
                  SizedBox(height: 20.0),
                ]; //Sized box before the first habit card.

                for (int i = 0; i < habitQueryList.length; i++) {
                  var habit = habitQueryList[i];
                  NotificationService().scheduleNotifications(i, habit);
                  // habit.
                  allHabitCard.add(
                    habitCard(habit),
                  );
                  allHabitCard.add(
                    SizedBox(height: 20.0),
                  );
                  print('Habit card ' +
                      habit.get('habit_name') +
                      ' generation successful.');
                }
                return Expanded(
                    child: Column(
                  children: allHabitCard,
                ));
              } else if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else {
                return Text('Error');
              }
            },
          ),
        ),
      ),
    );
  }

  Container habitCard(QueryDocumentSnapshot<Object> habitQuerySnapshot) {
    return Container(
      height: 250.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habitQuerySnapshot.get(habitNameKey),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      habitQuerySnapshot.get(triggerEventKey),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      convertReminderTimeFirebaseToReminderTimeString(
                          habitQuerySnapshot.get(reminderTimeKey)),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                  ],
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: habitQuerySnapshot.reference
                      .collection('history')
                      .snapshots(),
                  builder: (context, historySnapshot) {
                    List<String> frequency =
                        convertFrequencyFirebaseDataToDayListString(
                            habitQuerySnapshot.get('frequency'));

                    final now = DateTime.now();
                    final historyQueryList = historySnapshot.data.docs;
                    bool habitCompletedToday = false;
                    for (int i = 0; i < historyQueryList.length; i++) {
                      var historyTimestamp = DateTime.parse(historyQueryList[i]
                          .get('timestamp')
                          .toDate()
                          .toString());
                      if (historyTimestamp.isSameDate(now)) {
                        habitCompletedToday = true;
                      }
                    }

                    showSpinner = false;

                    if (habitCompletedToday)
                      return Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      );
                    else
                      return Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                      );
                  },
                ),
              ],
            ),
            buildChipForHabitCard(habitQuerySnapshot.get(frequencyKey)),
            SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                        child: Icon(
                          Icons.done,
                          color: Colors.green,
                        ),
                        onTap: () async {
                          String habitId = habitQuerySnapshot.id;
                          checkOffHabit(habitId);
                        }),
                    InkWell(
                      child: Icon(Icons.edit),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditHabitScreen({
                              'uid': loggedInUser.uid,
                              habitIdKey: habitQuerySnapshot.id,
                              habitNameKey:
                                  habitQuerySnapshot.get(habitNameKey),
                              triggerEventKey:
                                  habitQuerySnapshot.get(triggerEventKey),
                              reminderTimeKey:
                                  habitQuerySnapshot.get(reminderTimeKey),
                              frequencyKey:
                                  habitQuerySnapshot.get(frequencyKey),
                            }),
                          ),
                        );
                      },
                    ),
                    InkWell(
                      child: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onTap: () async {
                        showDialog(
                          context: context,
                          barrierDismissible: true,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Delete?'),
                              content: Text('Do you want to delete?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('No'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    deleteHabit(habitQuerySnapshot.id);
                                    Navigator.pop(context);
                                  },
                                  child: Text('Yes'),
                                )
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:ripeto_flutter/component.dart';
import 'package:ripeto_flutter/screens/add_habit_screen.dart';
import 'package:ripeto_flutter/screens/edit_habit_screen.dart';
import 'package:ripeto_flutter/service/auth_service.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  User loggedInUser;

  List<ListItem> _items = generateItems(5);

  final _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    getHabit();
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

  void getHabit() async {
    final uid = loggedInUser.uid;
    final habitMaps = await _firestore
        .collection('userData')
        .doc(uid)
        .collection('habit')
        .get();

    for (var habit in habitMaps.docs) {
      print(habit.data());
    }
  }

  void habitStream() async {
    final uid = loggedInUser.uid;
    await for (var snapshot in _firestore
        .collection('userData')
        .doc(uid)
        .collection('habit')
        .snapshots()) {
      for (var habit in snapshot.docs) {
        print(habit.data());
      }
    }
    ;
  }

  void deleteHabit(habitId) async {
    _firestore
        .collection('userData')
        .doc(loggedInUser.uid)
        .collection('habit')
        .doc(habitId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            homeScreenHeader(context),
            homeScreenBody(),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.redAccent),
              ),
              onPressed: () async {
                await _auth.signOut();
                Navigator.pop(context);
              },
              child: Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }

  Expanded homeScreenBody() {
    return Expanded(
      child: SingleChildScrollView(
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
                List<Widget> allHabitCard = [];

                for (var habit in habitQueryList) {
                  allHabitCard.add(
                    habitCard(habit),
                  );

                  allHabitCard.add(
                    SizedBox(
                      height: 20.0,
                    ),
                  );

                  print(habit.get('habit_name'));
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

  Padding homeScreenHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Habit List',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, AddHabitScreen.id);
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  Container habitCard(QueryDocumentSnapshot<Object> habit) {
    return Container(
      height: 160,
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
            Text(
              habit.get(habitNameKey),
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
              habit.get(triggerEventKey),
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 12.0,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              habit.get(reminderTimeKey),
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 12.0,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              habit.get(frequencyKey),
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 12.0,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.done,
                      color: Colors.green,
                    ),
                    InkWell(
                      child: Icon(Icons.edit),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          EditHabitScreen.id,
                          arguments:
                              //TODO: Refactor
                            'uid': loggedInUser.uid,
                            'habitId': habit.id,
                        habitNameKey: '',
                            triggerEventKey:'',
                            reminderTimeKey:'',
                            frequencyKey:'',


                          },
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
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('No'),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    deleteHabit(habit.id);
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

class ListItem {
  int id;
  String headerName;
  String description;
  bool isExpanded;

  ListItem({
    this.id,
    this.headerName,
    this.description,
    this.isExpanded = false,
  });
}

List<ListItem> generateItems(int numberOfItems) {
  return List<ListItem>.generate(numberOfItems, (int index) {
    return ListItem(
      id: index,
      headerName: 'Habit  $index',
      description: 'This is body of item number $index',
    );
  });
}

List<ExpansionPanel> _getExpansionPanels(List<ListItem> _items) {
  return _items.map<ExpansionPanel>((ListItem item) {
    return ExpansionPanel(
      headerBuilder: (BuildContext context, bool isExpanded) {
        return ListTile(
          title: Text(item.headerName),
        );
      },
      body: ListTile(
        title: Text(item.description),
      ),
      isExpanded: item.isExpanded,
    );
  }).toList();
}

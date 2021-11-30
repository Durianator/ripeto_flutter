import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ripeto_flutter/screens/add_habit_screen.dart';
import 'package:ripeto_flutter/service/auth_service.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  User loggedInUser;

  // List<ListItem> habitList;

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Padding(
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
            ),
            // Expanded(
            //   child: SingleChildScrollView(
            //     child: ExpansionPanelList(
            //       animationDuration: Duration(milliseconds: 1000),
            //       children: _getExpansionPanels(_items),
            //       expansionCallback: (panelIndex, isExpanded) {
            //         _items[panelIndex].isExpanded = !isExpanded;
            //         setState(() {});
            //       },
            //     ),
            //   ),
            // ),
            Expanded(
              child: SingleChildScrollView(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('userData')
                      .doc(loggedInUser.uid)
                      .collection('habit')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final habits = snapshot.data.docs;
                      List<ListItem> habitWidget = [];
                      for (var habit in habits) {
                        habitWidget.add(ListItem(
                          headerName: habit.get('habit_name') ?? '',
                          description: habit.get('reminder_time') ?? '',
                        ));
                        print(habit.get('habit_name'));
                      }
                      return ExpansionPanelList(
                        animationDuration: Duration(milliseconds: 1000),
                        children: _getExpansionPanels(habitWidget),
                        expansionCallback: (panelIndex, isExpanded) {
                          habitWidget[panelIndex].isExpanded = !isExpanded;
                          setState(() {});
                        },
                      );
                    } else if (!snapshot.hasData) {
                      return Text('No data');
                    } else {
                      return Text('Error');
                    }
                  },
                ),
              ),
            ),
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

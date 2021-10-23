import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<bool> _isOpen;

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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Habit List'),
                  ElevatedButton(
                    onPressed: () {
                      ;
                    },
                    child: Text('Add'),
                  ),
                ],
              ),
            ),
            ExpansionPanelList(
              expansionCallback: (i, isOpen) {
                setState(() {
                  _isOpen[i] = !isOpen;
                });
              },
              children: [
                ExpansionPanel(
                  headerBuilder: (context, isOpen) {
                    return Text('Hello World');
                  },
                  body: Text('Habit Name'),
                  isExpanded: _isOpen[0],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

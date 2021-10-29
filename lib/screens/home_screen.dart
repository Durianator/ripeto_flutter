import 'package:flutter/material.dart';

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
      headerName: 'Expansion Panel $index',
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

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ListItem> _items = generateItems(15);

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
            SingleChildScrollView(
              child: ExpansionPanelList(
                animationDuration: Duration(milliseconds: 1000),
                children: _getExpansionPanels(_items),
                expansionCallback: (panelIndex, isExpanded) {
                  _items[panelIndex].isExpanded = !isExpanded;
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

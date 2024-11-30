import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../querylist.dart';

class AddGoal extends StatefulWidget {
  final List<Map<String, dynamic>> goals;

  const AddGoal({super.key, required this.goals});

  @override
  State<AddGoal> createState() => _AddGoalState();
}

class _AddGoalState extends State<AddGoal> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  var currentUser = FirebaseAuth.instance.currentUser?.email;
  List<String> goalNames = [];
  List<Map<String,String>> groups = [];
  List<String> groupNames = [];
  final QueryList _queryList = QueryList();

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getGroups();
    findGoals();
    try {
      dropDownValue = groupNames.first;
    }
    catch (e) {}
  }

  Future<void> getGroups() async {
    if (groupNames.isNotEmpty) {
      groupNames.clear();
    }
    try {
      QuerySnapshot<Map<String, dynamic>> groupUserSnapshot =
      await _queryList.fetchList("groupUserList", "userEmail", FirebaseAuth.instance.currentUser!.email.toString());
      for (var groupUser in groupUserSnapshot.docs) {
        QuerySnapshot<Map<String, dynamic>> groupSnapshot =
        await _queryList.fetchList("groups", "group_ID", groupUser.data()["ID_group"]);
        for (var group in groupSnapshot.docs) {
          print(group.data());
          addGroup(group.data()["groupName"], group.data()["group_ID"]);
        }
      }
    } catch (e) {}
  }

  Future<void> addGroup(String name, String groupId) async {
    setState(() {
      groups.add({
        'name': name,
        'group_ID': groupId,
      });
      groupNames.add(name);
    });
  }

  Future<void> findGoals() async {
    for (var goal in widget.goals) {
      if (goal['email'] == currentUser) {
        print(goal['name']);
        goalNames.add(goal['name']);
      }
    }
  }

  void addGoal(String groupID, String name, String desc, DateTime dayStart, DateTime dayEnd) {
    final inputGoal = <String, dynamic>{
      'ID_group': groupID,
      'goalDayStart': dayStart,
      'goalDayEnd': dayEnd,
      'goalName': name,
      'goalText': desc,
      'userEmail': currentUser!
    };
    db.collection("goals").add(inputGoal).then((documentSnapshot) =>
        print("Added Data with ID: ${documentSnapshot.id}"));
    Navigator.pop(context);
  }

  String? dropDownValue;
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;
  DateTime _focusedDate = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.redAccent,
          title: Text(
            "Create Goal",
            style: TextStyle(fontSize: 20, color: Colors.white),
          )),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Group"),
            ),
            DropdownButton(
              value: dropDownValue,
              items: groupNames.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value, child: Text(value)
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  dropDownValue = value!;
                });
              }),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Name"),
            ),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Description"),
            ),
            TextField(
              controller: descController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Date Select"),
            ),
            TableCalendar(
              focusedDay: _focusedDate,
              firstDay: DateTime.now(),
              lastDay: DateTime(3000, 1, 1),
              rangeStartDay: _rangeStart,
              rangeEndDay: _rangeEnd,
              calendarFormat: _calendarFormat,
              rangeSelectionMode: _rangeSelectionMode,
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDate = focusedDay;
                  _rangeStart = null;
                  _rangeEnd = null;
                  _rangeSelectionMode = RangeSelectionMode.toggledOff;
                });
              },
              onRangeSelected: (start, end, focusedDay) {
                setState(() {
                  _selectedDay = null;
                  _focusedDate = focusedDay;
                  _rangeStart = start;
                  _rangeEnd = end;
                  _rangeSelectionMode = RangeSelectionMode.toggledOn;
                });
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (dropDownValue == null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Missing Group!")));
          }
          else if (_rangeStart == null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Missing Start Day!")));
          }
          else if (_rangeEnd == null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Missing Start End!")));
          }
          else {
            addGoal(dropDownValue!,nameController.text, descController.text, _rangeStart!, _rangeEnd!);
          }
        },
        child: Text("Enter"),
      ),
    );
  }
}

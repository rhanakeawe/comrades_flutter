import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class GroupAddGoal extends StatefulWidget {
  final String groupID;
  final List<Map<String, dynamic>> goals;

  const GroupAddGoal({super.key, required this.groupID, required this.goals});

  @override
  State<GroupAddGoal> createState() => _GroupAddGoalState();
}

class _GroupAddGoalState extends State<GroupAddGoal> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  var currentUser = FirebaseAuth.instance.currentUser?.email;
  List<String> goalNames = [];

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    findGoals();
  }

  Future<void> findGoals() async {
    for (var goal in widget.goals) {
      if (goal['email'] == currentUser) {
        print(goal['name']);
        goalNames.add(goal['name']);
      }
    }
  }

  void addGoal(String name, String desc, DateTime dayStart, DateTime dayEnd) {
    final inputGoal = <String, dynamic>{
      'ID_group': widget.groupID,
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
          addGoal(nameController.text, descController.text, _rangeStart!, _rangeEnd!);
        },
        child: Text("Enter"),
      ),
    );
  }
}

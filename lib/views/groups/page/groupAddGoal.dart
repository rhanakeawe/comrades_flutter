import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    startController.dispose();
    endController.dispose();
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

  void addGoal(String name, String desc, String dayStart, String dayEnd) {
    final inputGoal = <String, String>{
      'ID_group': widget.groupID,
      'goalDayCount': dayEnd,
      'goalDayStart': dayStart,
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
  final startController = TextEditingController();
  final endController = TextEditingController();
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
              child: Text("DayStart"),
            ),
            TextField(
              controller: startController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'DayStart',
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("DayEnd"),
            ),
            TextField(
              controller: endController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'DayEnd',
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addGoal(nameController.text, descController.text,
              startController.text, endController.text);
        },
        child: Text("Enter"),
      ),
    );
  }
}

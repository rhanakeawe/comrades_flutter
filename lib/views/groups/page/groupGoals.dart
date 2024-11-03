import 'package:flutter/material.dart';

class GroupGoalsPage extends StatefulWidget {
  final String groupID;

  const GroupGoalsPage({
    super.key,
    required this.groupID,
  });

  @override
  State<GroupGoalsPage> createState() => _GroupGoalsPageState();
}

class _GroupGoalsPageState extends State<GroupGoalsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("Goals", style: TextStyle(fontSize: 20, color: Colors.white),),
      ),
      body: Column(
        children: [
          SizedBox(height: 10,)
        ],
      ),
    );
  }
}
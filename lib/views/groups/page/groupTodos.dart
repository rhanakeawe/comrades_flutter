import 'package:flutter/material.dart';

class GroupTodosPage extends StatefulWidget {
  final String groupID;

  const GroupTodosPage({
    super.key,
    required this.groupID,
  });

  @override
  State<GroupTodosPage> createState() => _GroupTodosPageState();
}

class _GroupTodosPageState extends State<GroupTodosPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("To-Dos", style: TextStyle(fontSize: 20, color: Colors.white),),
      ),
      body: Column(
        children: [
          SizedBox(height: 10,)
        ],
      ),
    );
  }
}
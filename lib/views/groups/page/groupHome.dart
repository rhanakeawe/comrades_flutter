import 'package:flutter/material.dart';

class GroupHomePage extends StatefulWidget {
  final String groupID;

  const GroupHomePage({
    super.key,
    required this.groupID,
  });

  @override
  State<GroupHomePage> createState() => _GroupHomePageState();
}

class _GroupHomePageState extends State<GroupHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("Home", style: TextStyle(fontSize: 20, color: Colors.white),),
      ),
      body: Column(
        children: [
          SizedBox(height: 10,)
        ],
      ),
    );
  }
}
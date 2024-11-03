import 'package:flutter/material.dart';

class GroupAnnouncementsPage extends StatefulWidget {
  final String groupID;

  const GroupAnnouncementsPage({
    super.key,
    required this.groupID,
  });

  @override
  State<GroupAnnouncementsPage> createState() => _GroupAnnouncementsPageState();
}

class _GroupAnnouncementsPageState extends State<GroupAnnouncementsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("Announcements", style: TextStyle(fontSize: 20, color: Colors.white),),
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
        ],
      ),
    );
  }
}
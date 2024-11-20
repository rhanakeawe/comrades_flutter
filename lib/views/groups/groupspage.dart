import 'package:Comrades/views/groups/page/groupAnnouncements.dart';
import 'package:Comrades/views/groups/page/groupGoals.dart';
import 'package:Comrades/views/groups/page/groupHome.dart';
import 'package:Comrades/views/groups/page/groupTodos.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'page/groupMembers.dart';

class GroupsPage extends StatelessWidget {
  final String groupName;
  final String groupID;
  final String backgroundImage;

  const GroupsPage({
    super.key,
    required this.groupName,
    required this.groupID,
    required this.backgroundImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(groupID),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Group header with background image or default color
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey,
              image: DecorationImage(
                image: CachedNetworkImageProvider(backgroundImage),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              groupName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              children: [
                _buildMenuItem(context, GroupHomePage(groupID: groupID),
                    Icon(Icons.home, color: Colors.redAccent), "Home"),
                _buildMenuItem(context, GroupMembersPage(groupID: groupID),
                    Icon(Icons.people, color: Colors.redAccent), "Members"),
                _buildMenuItem(
                    context,
                    GroupAnnouncementsPage(groupID: groupID),
                    Icon(Icons.announcement, color: Colors.redAccent),
                    "Announcements"),
                _buildMenuItem(context, GroupGoalsPage(groupID: groupID),
                    Icon(Icons.description, color: Colors.redAccent), "Goals"),
                _buildMenuItem(
                    context,
                    GroupTodosPage(groupID: groupID),
                    Icon(Icons.restore_from_trash, color: Colors.redAccent),
                    "To-Dos"),
                // what else should I add?
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context, Widget widget, Icon icon, String title) {
    return ListTile(
      leading: icon,
      title: Text(title, style: TextStyle(color: Colors.black)),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => widget),
        );
      },
    );
  }
}

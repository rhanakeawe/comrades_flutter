import 'package:flutter/material.dart';

import 'groupMembers.dart';

class GroupsPage extends StatelessWidget {
  final String groupName;
  final String groupID;
  final String? backgroundImage;

  const GroupsPage({
    super.key,
    required this.groupName,
    required this.groupID,
    this.backgroundImage,
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
              image: backgroundImage != null
                  ? DecorationImage(
                image: NetworkImage(backgroundImage!),
                fit: BoxFit.cover,
              )
                  : null,
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
                _buildMenuItem(context, 'Home', Icons.home),
                ListTile(
                  leading: Icon(Icons.people, color: Colors.redAccent),
                  title: Text("Members", style: TextStyle(color: Colors.black)),
                  trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GroupMembersPage(groupID: groupID,)),
                    );
                  },
                ),
                _buildMenuItem(context, 'Announcements', Icons.announcement),
                _buildMenuItem(context, 'Goals', Icons.description),
                _buildMenuItem(context, 'To Do\'s', Icons.restore_from_trash),
                // what else should I add?
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to create each menu item
  Widget _buildMenuItem(BuildContext context, String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.redAccent),
      title: Text(title, style: TextStyle(color: Colors.black)),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SectionPage(title: title), // Placeholder for each section page
          ),
        );
      },
    );
  }
}

// Placeholder for each section in GroupsPage
class SectionPage extends StatelessWidget {
  final String title;

  const SectionPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(
          'Welcome to the $title section!', // pretty useful the $title
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              'Karl Marx',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            accountEmail: Text(
              'karlmarx@csu.fullerton.edu',
              style: TextStyle(
                color: Colors.white70,
              ),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/profile_picture.jpg'), // Replace with your profile picture
            ),
            decoration: BoxDecoration(
              color: Colors.red, // Replace with preferred color
            ),
          ),
          ListTile(
            leading: Icon(Icons.assist_walker),
            title: Text('Non-negotiables'),
            onTap: () {
              // Navigate to Files screen
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.cake_outlined), // Changed icon
            title: Text('Idk'),
            onTap: () {
              // Navigate to Studio screen
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              // Navigate to Settings screen
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Help'),
            onTap: () {
              // Navigate to Help screen
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.pregnant_woman),
            title: Text('Get Pregnant'),
            onTap: () {
              // Handle change user functionality
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log Out'),
            onTap: () {
              // Handle log out functionality
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

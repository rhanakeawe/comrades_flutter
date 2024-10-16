import 'package:flutter/material.dart';


class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    String userName = "Karl Marx";
    String userEmail = "karlmarx@csu.fullerton.edu";

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              userName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            accountEmail: Text(
              userEmail,
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('assets/profile_picture.jpg'), // Replace with your profile picture
            ),
            decoration: const BoxDecoration(
              color: Colors.red, // Replace with preferred color
            ),
          ),
          ListTile(
            leading: const Icon(Icons.assist_walker),
            title: const Text('Non-negotiables'),
            onTap: () {
              // Navigate to Files screen
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.cake_outlined), // Changed icon
            title: const Text('Idk'),
            onTap: () {
              // Navigate to Studio screen
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // Navigate to Settings screen
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Help'),
            onTap: () {
              // Navigate to Help screen
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.pregnant_woman),
            title: const Text('Get Pregnant'),
            onTap: () {
              // Handle change user functionality
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
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

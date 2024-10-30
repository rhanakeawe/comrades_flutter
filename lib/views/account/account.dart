import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:Comrades/views/auth/loginpage.dart';

class AccountDrawer extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String userImage;
  final Function(int) onItemTapped;
  final int selectedIndex;

  const AccountDrawer({
    required this.userName,
    required this.userEmail,
    required this.userImage,
    required this.onItemTapped,
    required this.selectedIndex,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
            currentAccountPicture: CircleAvatar(
              backgroundImage: userImage.isNotEmpty
                  ? NetworkImage(userImage)
                  : const AssetImage('assets/profile_picture.jpg') as ImageProvider,
            ),
            decoration: const BoxDecoration(
              color: Colors.red, // Replace with preferred color
            ),
          ),
          ListTile(
            selected: selectedIndex == 5,
            leading: const Icon(Icons.assist_walker),
            title: const Text('Non-negotiables'),
            onTap: () {
              onItemTapped(5); // Navigate to Non-negotiables
              Navigator.pop(context);
            },
          ),
          ListTile(
            selected: selectedIndex == 6,
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              onItemTapped(6); // Navigate to Settings
              Navigator.pop(context);
            },
          ),
          ListTile(
            selected: selectedIndex == 7,
            leading: const Icon(Icons.help),
            title: const Text('Help'),
            onTap: () {
              onItemTapped(7); // Navigate to Help
              Navigator.pop(context);
            },
          ),
          ListTile(
            selected: selectedIndex == 8,
            leading: const Icon(Icons.pregnant_woman),
            title: const Text('Get Pregnant'),
            onTap: () {
              onItemTapped(8); // Navigate to Pregnant
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () {
              FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

import 'package:Comrades/data/manageCache.dart';
import 'package:Comrades/main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountDrawer extends StatefulWidget {
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
  State<AccountDrawer> createState() => _AccountDrawerState();
}

class _AccountDrawerState extends State<AccountDrawer> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final manageCache = ManageCache();
  signOut() async {
    await auth.signOut();
    await manageCache.clearAllCache();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyApp()));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              widget.userName,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            accountEmail: Text(
              widget.userEmail,
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
            currentAccountPicture: CachedNetworkImage(
              imageUrl: widget.userImage,
              imageBuilder: (context, imageProvider) => CircleAvatar(
                backgroundImage: imageProvider,
              ),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            decoration: const BoxDecoration(
              color: Colors.red, // Replace with preferred color
            ),
          ),
          ListTile(
            selected: widget.selectedIndex == 5,
            leading: const Icon(Icons.assist_walker),
            title: const Text('Non-negotiables'),
            onTap: () {
              widget.onItemTapped(5); // Navigate to Non-negotiables
              Navigator.pop(context);
            },
          ),
          ListTile(
            selected: widget.selectedIndex == 6,
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              widget.onItemTapped(6); // Navigate to Settings
              Navigator.pop(context);
            },
          ),
          ListTile(
            selected: widget.selectedIndex == 7,
            leading: const Icon(Icons.help),
            title: const Text('Help'),
            onTap: () {
              widget.onItemTapped(7); // Navigate to Help
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: signOut,
          ),
        ],
      ),
    );
  }
}

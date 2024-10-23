import 'package:Comrades/views/account/account_settings.dart';
import 'package:Comrades/views/account/idk.dart';
import 'package:Comrades/views/account/non-negotiables.dart';
import 'package:Comrades/views/account/pregnant.dart';
import 'package:Comrades/views/auth/loginpage.dart';
import 'package:Comrades/views/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Comrades/views/account/help.dart';
import 'package:Comrades/views/settings/settings.dart';
import 'package:Comrades/views/groups/groups.dart'; // Import your GroupsPage here

// Make sure to import your CreateGroupScreen

void main() {
  runApp(const MyApp());
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  int _selectedIndex = 0;
  String selectedPage = 'Home Page';
  late String userName = "";
  late String userEmail = "";
  late String userImage = "";

  // Define the list of widgets (without const)
  List<Widget> widgetList = [
    GroupsPage(), // Add GroupsPage to the list
    Non_negotiables(),
    idk(),
    Account_Settings(),
    Help(),
    Pregnant()
  ];

  void getUserData() {
    db.collection("users").where("email", isEqualTo: FirebaseAuth.instance.currentUser?.email).get().then(
          (users) {
        print("Successfully queried user!");
        for (var user in users.docs) {
          setState(() {
            userName = user.data()["name"];
            userEmail = user.data()["email"];
            userImage = user.data()["profilepic"];
          });
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userName.isEmpty) {
      getUserData();
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return FractionallySizedBox(
                      heightFactor: 0.9,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20.0,
                            child: AppBar(
                              toolbarHeight: 30.0,
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Done',
                                    style: GoogleFonts.roboto(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                              automaticallyImplyLeading: false,
                              backgroundColor: Colors.red,
                            ),
                          ),
                          const Expanded(child: SettingsScreen()),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
          title: Image.asset('assets/Comrades40.png', height: 100),
          centerTitle: true,
          backgroundColor: Colors.red,
          leading: Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                iconSize: 32,
                color: Colors.white,
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ),
      ),
      drawerEnableOpenDragGesture: false,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                userName,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
              ),
              accountEmail: Text(
                userEmail,
                style: const TextStyle(color: Colors.white70),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundImage: Image.network(userImage).image,
              ),
              decoration: const BoxDecoration(
                color: Colors.red,
              ),
            ),
            // REMOVE or COMMENT OUT the Groups ListTile here
            /*
            ListTile(
              selected: _selectedIndex == 0,
              leading: const Icon(Icons.home_rounded),
              title: const Text('Groups'),
              onTap: () {
                _onItemTapped(0); // Navigate to GroupsPage
                Navigator.pop(context);
              },
            ),
            */
            ListTile(
              selected: _selectedIndex == 1,
              leading: const Icon(Icons.assist_walker),
              title: const Text('Non-negotiables'),
              onTap: () {
                _onItemTapped(1); // Navigate to Non-negotiables
                Navigator.pop(context);
              },
            ),
            ListTile(
              selected: _selectedIndex == 2,
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                _onItemTapped(2); // Navigate to Settings
                Navigator.pop(context);
              },
            ),
            ListTile(
              selected: _selectedIndex == 3,
              leading: const Icon(Icons.help),
              title: const Text('Help'),
              onTap: () {
                _onItemTapped(3); // Navigate to Help
                Navigator.pop(context);
              },
            ),
            ListTile(
              selected: _selectedIndex == 4,
              leading: const Icon(Icons.pregnant_woman),
              title: const Text('Get Pregnant'),
              onTap: () {
                _onItemTapped(4); // Navigate to Pregnant
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
      ),
      backgroundColor: Colors.black,
      body: IndexedStack(
        index: _selectedIndex,
        children: widgetList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped, // Update _selectedIndex on tap
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Groups',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
            backgroundColor: Colors.orange,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag_rounded),
            label: 'Goals',
            backgroundColor: Colors.yellow,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_rounded),
            label: 'Notifications',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox_rounded),
            label: 'Inbox',
            backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}

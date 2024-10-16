import 'package:Comrades/views/account_views/account_settings.dart';
import 'package:Comrades/views/account_views/idk.dart';
import 'package:Comrades/views/account_views/non-negotiables.dart';
import 'package:Comrades/views/account_views/pregnant.dart';
import 'package:Comrades/views/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'account_views/help.dart';
// Make sure to import your CreateGroupScreen
import 'package:Comrades/views/settings.dart';

// Maybe make the home page the calendar page since it'll be the focus
void main() {
  runApp(const MyApp());
}

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  int _selectedIndex = 0;
  String selectedPage = 'Home Page';
  String userName = "Karl Marx";
  String userEmail = "karlmarx@csu.fullerton.edu";
  //Todo: Add BottomNav pages to beginning of list
  List<Widget> widgetList = const [
    Non_negotiables(),
    idk(),
    Account_Settings(),
    Help(),
    Pregnant()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: AppBar(
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
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
                                      'Done', // ** need help removing > button
                                      // 'Done' is there but just isn't shown cause
                                      // > button is in the way
                                      style: GoogleFonts.roboto(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ],
                                automaticallyImplyLeading:
                                    false, // should remove > button but idk
                                backgroundColor: Colors.red,
                              ),
                            ),
                            const Expanded(
                              child: SettingsScreen(), // settings screen widget
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
            title: Image.asset(
              'assets/Comrades40.png',
              height: 100, // adjusts height of the logo up top
            ),
            centerTitle: true, // Centers the title/logo in the app bar
            backgroundColor: Colors.red, // thinking maybe a blood red?
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon:
                      const Icon(Icons.menu), // new place to enter account.dart
                  iconSize: 32, // size of hamburger button
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
                  backgroundImage: AssetImage(
                      'assets/profile_picture.jpg'), // Replace with your profile picture
                ),
                decoration: const BoxDecoration(
                  color: Colors.red, // Replace with preferred color
                ),
              ),
              // Todo: Shift these index numbers after BottomNav
              ListTile(
                selected: _selectedIndex == 0,
                leading: const Icon(Icons.assist_walker),
                title: const Text('Non-negotiables'),
                onTap: () {
                  // Navigate to Files screen
                  _onItemTapped(0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                selected: _selectedIndex == 1,
                leading: const Icon(Icons.cake_outlined), // Changed icon
                title: const Text('Idk'),
                onTap: () {
                  // Navigate to Studio screen
                  _onItemTapped(1);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                selected: _selectedIndex == 2,
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  // Navigate to Settings screen
                  _onItemTapped(2);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                selected: _selectedIndex == 3,
                leading: const Icon(Icons.help),
                title: const Text('Help'),
                onTap: () {
                  // Navigate to Help screen
                  _onItemTapped(3);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                selected: _selectedIndex == 4,
                leading: const Icon(Icons.pregnant_woman),
                title: const Text('Get Pregnant'),
                onTap: () {
                  // Handle change user functionality
                  _onItemTapped(4);
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
        ),
        backgroundColor: Colors.black,
        body: IndexedStack(
          index: _selectedIndex,
          children: widgetList,
        ));
  }
}

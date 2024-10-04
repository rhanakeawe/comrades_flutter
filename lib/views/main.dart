import 'package:comrades_flutter/views/account.dart';
import 'package:comrades_flutter/views/friends.dart';
import 'package:comrades_flutter/views/home.dart';
import 'package:comrades_flutter/views/settings.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MainScreen());
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int myIndex = 0;
  List<Widget> widgetList = const [
    HomeScreen(),
    AccountScreen(),
    FriendsScreen(),
    SettingsScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: IndexedStack(
          index: myIndex,
          children: widgetList,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          onTap: (index) {
            setState(() {
              myIndex = index;
            });
          },
          currentIndex: myIndex,
          showSelectedLabels: false,
          selectedLabelStyle: const TextStyle(color: Colors.blue),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home, color: Colors.white),
                label: 'Home',
                backgroundColor: Colors.red),
            BottomNavigationBarItem(
                icon: Icon(Icons.person, color: Colors.white),
                label: 'Account',
                backgroundColor: Colors.red),
            BottomNavigationBarItem(
                icon: Icon(Icons.people, color: Colors.white),
                label: 'Friends',
                backgroundColor: Colors.red),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings, color: Colors.white),
                label: 'Settings',
                backgroundColor: Colors.red)
          ],
        ),
      ),
    );
  }
}

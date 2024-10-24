import 'package:Comrades/views/goals/goals.dart';
import 'package:Comrades/views/inbox/inbox.dart';
import 'package:Comrades/views/notifications/notifications.dart';
import 'package:Comrades/views/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:Comrades/views/account/account.dart';
import 'package:Comrades/views/groups/groups.dart';
import 'package:Comrades/views/calendar/calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  int _selectedIndex = 0;
  String userName = "";
  String userEmail = "";
  String userImage = "";

  List<Widget> widgetList = [
    GroupsPage(),         // index 0 -> Groups Page
    CalendarPage(),       // index 1 -> Calendar Page
    GoalsPage(),          // index 2 -> Groups Page
    NotificationsPage(),  // index 3 -> Notifications Page
    InboxPage(),          // index 4 -> Inbox Page
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
                    return SettingsScreen();
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
      drawer: AccountDrawer(
        userName: userName,
        userEmail: userEmail,
        userImage: userImage,
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
      backgroundColor: Colors.black,
      body: IndexedStack(
        index: _selectedIndex,
        children: widgetList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
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

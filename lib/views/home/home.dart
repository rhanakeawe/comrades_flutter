import 'dart:async';
import 'dart:convert';

import 'package:Comrades/data/manageCache.dart';
import 'package:Comrades/data/userData.dart';
import 'package:Comrades/main.dart';
import 'package:Comrades/views/account/account_settings.dart';
import 'package:Comrades/views/goals/goals.dart';
import 'package:Comrades/views/inbox/inbox.dart';
import 'package:Comrades/views/notifications/notifications.dart';
import 'package:Comrades/views/account/help.dart';
import 'package:Comrades/views/account/non-negotiables.dart';
import 'package:flutter/material.dart';
import 'package:Comrades/views/account/account.dart';
import 'package:Comrades/views/groups/groups.dart';
import 'package:Comrades/views/calendar/calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


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
  UserData? user;

  List<Widget> widgetList = [
    Groups(), // index 0 -> Groups Page
    CalendarPage(), // index 1 -> Calendar Page
    GoalsPage(), // index 2 -> Groups Page
    NotificationsPage(), // index 3 -> Notifications Page
    InboxPage(), // index 4 -> Inbox Page
    NonNegotiablesPage(),
    Account_Settings(),
    Help(),
  ];

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    final loadCache = ManageCache();
    final cachedUserData = await loadCache.loadDataFromCache('user_data.json');
    if (cachedUserData != null) {
      final user = UserData.fromJson(jsonDecode(cachedUserData));
      print('User loaded: ${user.userName}');
      setState(() {
        userName = user.userName;
        userEmail = user.email;
        userImage = user.profilePic;
      });
    } else {
      print('No user cache found');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MyApp()));
      });
    }
  }

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
        selectedIndex: _selectedIndex > 4 ? _selectedIndex : 0,
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
        currentIndex: _selectedIndex <= 4 ? _selectedIndex : 0,
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
            icon: Icon(Icons.inbox_rounded),
            label: 'Inbox',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_rounded),
            label: 'Notifications',
            backgroundColor: Colors.green,
          ),

        ],
      ),
    );
  }
}

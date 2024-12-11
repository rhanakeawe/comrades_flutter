import 'dart:convert';

import 'package:Comrades/data/notificationSettingData.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/manageCache.dart';
import '../../data/userData.dart';
import '../../main.dart';

class Account_Settings extends StatefulWidget {
  const Account_Settings({super.key});

  @override
  State<Account_Settings> createState() => _Account_SettingsState();
}

class _Account_SettingsState extends State<Account_Settings> {
  bool valNotify1 = true;
  bool valNotify2 = false;
  bool valNotify3 = false;
  String userName = "";
  String userEmail = "";
  String userImage = "";
  final manageCache =  ManageCache();

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

  Future<void> showNotifications(bool newValue1) async {
    var loadedNotificationSetting = await manageCache.loadListFromCache('notification_setting.json');
    List<NotificationSettingData> notificationData = [];
    notificationData.add(NotificationSettingData(toggled: newValue1.toString()));
    if (loadedNotificationSetting == null) {
      await manageCache.saveListToCache('notification_setting.json', notificationData);
    } else {
      await manageCache.deleteCache('notification_setting.json');
      await manageCache.saveListToCache("notification_setting.json", notificationData);
    }
    setState(() {
      valNotify1 = newValue1;
    });
  }

  void announcementsToggle(bool newValue2) {
    setState(() {
      valNotify2 = newValue2;
    });
  }

  void receiveNews(bool newValue3) {
    setState(() {
      valNotify3 = newValue3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CachedNetworkImage(
                      imageUrl: userImage,
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        backgroundImage: imageProvider,
                      ),
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(userName, style: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),),
                  Text("($userEmail)", style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey[600]),)
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: ListView(
                  children: [
                    SizedBox(height: 10),
                    Text(
                      'Account settings',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      ),
                    ),
                    Divider(height: 20, thickness: 1),
                    SizedBox(height: 10),
                    buildAccountOption(context, "Change Password"),
                    buildAccountOption(context, "Content Settings"),
                    buildAccountOption(context, "Social"),
                    buildAccountOption(context, "Language"),
                    buildAccountOption(context, "Privacy and Security"),
                    SizedBox(height: 40),
                    Row(
                      children: [
                        Icon(Icons.volume_up_outlined, color: Colors.blue),
                        SizedBox(width: 10),
                        Text(
                          "Notifications",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                          ),
                        ),
                      ],
                    ),
                    Divider(height: 20, thickness: 1),
                    SizedBox(height: 10),
                    buildNotificationOption("Show Notifications", valNotify1, showNotifications),
                    buildNotificationOption("Announcements", valNotify2, announcementsToggle),
                    buildNotificationOption("Receive Newsletter", valNotify3, receiveNews),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding buildNotificationOption(String title, bool value, Function(bool) onChangeMethod) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              activeColor: Colors.blue,
              trackColor: Colors.grey,
              value: value,
              onChanged: (bool newValue) {
                onChangeMethod(newValue);
              },
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector buildAccountOption(BuildContext context, String title) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(title),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Close"),
                ),
              ],
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

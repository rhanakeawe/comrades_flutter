import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Account_Settings extends StatefulWidget {
  const Account_Settings({super.key});

  @override
  State<Account_Settings> createState() => _Account_SettingsState();
}

class _Account_SettingsState extends State<Account_Settings> {
  bool valNotify1 = true;
  bool valNotify2 = false;
  bool valNotify3 = false;

  void onChangeFunction1(bool newValue1) {
    setState(() {
      valNotify1 = newValue1;
    });
  }

  void onChangeFunction2(bool newValue2) {
    setState(() {
      valNotify2 = newValue2;
    });
  }

  void onChangeFunction3(bool newValue3) {
    setState(() {
      valNotify3 = newValue3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: FractionallySizedBox(
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
            Expanded(
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.person,
                    color: Colors.green,
                  ),

                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
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
                                ),
                              ),
                            ],
                          ),
                          Divider(height: 20, thickness: 1),
                          SizedBox(height: 10),
                          buildNotificationOption("Show Notifications", valNotify1, onChangeFunction1),
                          buildNotificationOption("Annocunments", valNotify2, onChangeFunction2),
                          buildNotificationOption("Revieve NewsLetter", valNotify3, onChangeFunction3),
                        ],
                      ),
                    ),
                  ),
                ],
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
              color: Colors.grey[600],
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
                children: [
                  Text("Option 1"),
                  Text("Option 2"),
                ],
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
                color: Colors.grey[600],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

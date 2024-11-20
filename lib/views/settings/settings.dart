import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          // Add your settings options here
          const Expanded(
              child: Column(
                children: <Widget> [
                  Card(
                    child: ListTile(
                      title: Text("Account Username")
                    )
                  ),

                  Icon(
                      Icons.person,
                      color: Colors.green
                  ),
                  Text('Account settings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),

                  Icon(
                    Icons.dark_mode,
                        color: Colors.blue,

                  ),
                  SizedBox(width:10),
                  Text('Dark Mode'),

                  Icon(
                      Icons.logout,
                      color: Colors.red
                  ),
                  Text('Logout'),


                  Icon(
                      Icons.password,
                      color: Colors.red
                  ),
                  Text('Password')

                ],
              )),





        ],
      ),
    );
  }
}
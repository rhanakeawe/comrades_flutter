import 'package:Comrades/views/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'create_group.dart'; // Make sure to import your CreateGroupScreen
import 'package:Comrades/views/account.dart';
import 'package:Comrades/views/friends.dart';
import 'package:Comrades/views/home.dart';
import 'package:Comrades/views/settings.dart';

// Maybe make the home page the calendar page since it'll be the focus
void main() {
  runApp(const MyApp());
}

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

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
                              automaticallyImplyLeading: false, // should remove > button but idk
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
          leading: IconButton(
            icon: const Icon(Icons.menu), // new place to enter account.dart
            iconSize: 32, // size of hamburger button
            color: Colors.white,
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'Calendar page needs hhto gddo here', // Updated placeholder text
          style: GoogleFonts.roboto(
            fontSize: 18, // Customize font with Google Fonts
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
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
          const Expanded(child: Text('Settings')),
        ],
      ),
    );
  }
}

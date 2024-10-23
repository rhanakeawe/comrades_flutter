import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'Friennds',
          style: GoogleFonts.teko(color: Colors.white, fontSize: 48),
        ),
      ),
    );
  }
}
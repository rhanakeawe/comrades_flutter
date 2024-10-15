import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          'Help',
          style: GoogleFonts.teko(color: Colors.white, fontSize: 48),
        ),
      ),
    );
  }
}
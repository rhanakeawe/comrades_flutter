import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Non_negotiables extends StatelessWidget {
  const Non_negotiables({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          'Non_negotiables',
          style: GoogleFonts.teko(color: Colors.white, fontSize: 48),
        ),
      ),
    );
  }
}

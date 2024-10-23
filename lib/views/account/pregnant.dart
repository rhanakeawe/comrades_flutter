import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Pregnant extends StatelessWidget {
  const Pregnant({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          'Pregnant',
          style: GoogleFonts.teko(color: Colors.white, fontSize: 48),
        ),
      ),
    );
  }
}
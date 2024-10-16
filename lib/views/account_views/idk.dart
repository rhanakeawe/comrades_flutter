import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class idk extends StatelessWidget {
  const idk({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          'idk',
          style: GoogleFonts.teko(color: Colors.white, fontSize: 48),
        ),
      ),
    );
  }
}

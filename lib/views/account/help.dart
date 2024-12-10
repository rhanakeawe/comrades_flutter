import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Having issues with Comrades? Email comrades.project362@gmail.com to resolve all issues. Thanks!',
        style: GoogleFonts.teko(color: Colors.white, fontSize: 48),
      ),
    );
  }
}

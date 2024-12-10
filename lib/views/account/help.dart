import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Having issues with Comrades?',
              style: GoogleFonts.teko(color: Colors.white, fontSize: 48),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 100,
            ),
            Text(
              'Email comrades.project362@gmail.com to resolve all issues. Thanks!',
              style: GoogleFonts.teko(color: Colors.white, fontSize: 40),
              textAlign: TextAlign.center,
            ),
            ElevatedButton(
                onPressed: () async {
                  await Clipboard.setData(
                      ClipboardData(text: "comrades.project362@gmail.com"));
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text("Copy to Clipboard"), Icon(Icons.copy)],
                )),
          ],
        ),
      ),
    );
  }
}

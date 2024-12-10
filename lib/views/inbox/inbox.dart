import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class InboxPage extends StatelessWidget {
  // Declare controllers
  final TextEditingController controllerTo = TextEditingController();
  final TextEditingController controllerSubject = TextEditingController();
  final TextEditingController controllerMessage = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Inbox', style: GoogleFonts.roboto(fontSize: 25, color: Colors.white),), // Title of the app bar
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            buildTextField(title: 'To', controller: controllerTo),
            const SizedBox(height: 16),
            buildTextField(title: 'Subject', controller: controllerSubject),
            const SizedBox(height: 16),
            buildTextField(
              title: 'Message',
              controller: controllerMessage,
              maxLines: 8,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size.fromHeight(50),
                textStyle: TextStyle(fontSize: 20),
              ),
              child: Text('SEND', style: GoogleFonts.roboto(fontSize: 20, color: Colors.black),),
              onPressed: () {
                launch(
                  toEmail: controllerTo.text,
                  subject: controllerSubject.text,
                  message: controllerMessage.text,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> launch({
    required String toEmail,
    required String subject,
    required String message,
  }) async {
    final Uri url = Uri(
      scheme: 'mailto',
      path: toEmail,
      query: 'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(message)}',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  // Helper method to build the text fields
  Widget buildTextField({
    required String title,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}

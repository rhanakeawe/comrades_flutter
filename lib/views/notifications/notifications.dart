import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.indigo,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            const Text(
              "Notification Settings",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            SwitchListTile(
              activeColor: Colors.purple,
              contentPadding: const EdgeInsets.all(0),
              value: true,
              title: const Text("Receive notifications"),
              onChanged: (val) {
                // Handle switch toggle here
              },
            ),
            SwitchListTile(
              activeColor: Colors.purple,
              contentPadding: const EdgeInsets.all(0),
              value: true,
              title: const Text("Receive newsletter"),
              onChanged: null, // Disabled switch
            ),
            SwitchListTile(
              activeColor: Colors.purple,
              contentPadding: const EdgeInsets.all(0),
              value: false,
              title: const Text("Receive offer notifications"),
              onChanged: (val) {
                // Handle switch toggle here
              },
            ),
          ],
        ),
      ),
    );
  }
}

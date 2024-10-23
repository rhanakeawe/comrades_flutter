import 'package:flutter/material.dart';

class GroupCardEditScreen extends StatelessWidget {
  final String groupName;

  GroupCardEditScreen({required this.groupName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customize Group'),
        backgroundColor: Colors.red,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Done',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              groupName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 20),
            Text(
              'Nickname',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter group nickname',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Color',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Wrap(
              spacing: 10.0,
              children: [
                for (var color in [Colors.pink, Colors.purple, Colors.blue, Colors.green, Colors.orange, Colors.grey])
                  GestureDetector(
                    onTap: () {
                      // Handle color change logic here
                    },
                    child: CircleAvatar(
                      backgroundColor: color,
                      radius: 20,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Add a picture',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            ElevatedButton(
              onPressed: () {
                // Add logic to pick an image from the photo library
              },
              child: Text('Choose from gallery'),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}

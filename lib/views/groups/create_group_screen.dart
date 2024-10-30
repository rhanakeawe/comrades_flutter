import 'package:flutter/material.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _groupDescriptionController = TextEditingController();
  String? backgroundImage;

  void createGroup() {
    final name = _groupNameController.text;
    final description = _groupDescriptionController.text;

    if (name.isNotEmpty && description.isNotEmpty) {
      Navigator.pop(context, {
        'name': name,
        'description': description,
        'backgroundImage': backgroundImage,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both a name and description')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Group'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _groupNameController,
              decoration: InputDecoration(
                labelText: 'Group Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _groupDescriptionController,
              decoration: InputDecoration(
                labelText: 'Group Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // Placeholder for adding a background image
            TextButton(
              onPressed: () {
                // needs logic for picking an image here
                setState(() {
                  backgroundImage = 'assets/sample_image.png'; // gotta add a test pic
                });
              },
              child: Text('Select Background Image'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: createGroup,
              child: Text('Save Group'),
            ),
          ],
        ),
      ),
    );
  }
}

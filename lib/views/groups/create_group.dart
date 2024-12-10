import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  String groupName = '';
  String groupDesc = '';
  String groupID = '';
  File? backgroundImage; // File to store the selected image

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        backgroundImage = File(pickedFile.path);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image selected')),
      );
    }
  }

  void _saveGroup() {
    if (groupName.isEmpty || groupDesc.isEmpty || groupID.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields.')),
      );
      return;
    }

    // Logic to save group, e.g., Firestore
    print('Group saved: $groupName, $groupDesc, $groupID');
    if (backgroundImage != null) {
      print('Background image selected: ${backgroundImage!.path}');
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Group'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Group Name'),
                onChanged: (value) {
                  setState(() {
                    groupName = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(labelText: 'Group Description'),
                onChanged: (value) {
                  setState(() {
                    groupDesc = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(labelText: '@Group ID'),
                onChanged: (value) {
                  setState(() {
                    groupID = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _pickImage,
                child: const Text('Select Background Image'),
              ),
              if (backgroundImage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Image.file(
                    backgroundImage!,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveGroup,
                child: const Text('Save Group'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController groupDescriptionController =
      TextEditingController();
  final TextEditingController groupIDController = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;
  var currentUser = FirebaseAuth.instance.currentUser?.email;
  File? imageFile;

  Future<void> pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      String fileName =
          'group_background/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference storageRef = FirebaseStorage.instance.ref(fileName);
      await storageRef.putFile(imageFile);
      String bucket = FirebaseStorage.instance.bucket;
      return '$bucket/$fileName';
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> createGroup() async {
    if (groupNameController.text.isEmpty ||
        groupDescriptionController.text.isEmpty ||
        groupIDController.text.isEmpty ||
        imageFile == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please fill all fields.')));
      return;
    } else {
      try {
        String? imageURL = await _uploadImage(imageFile!);
        if (imageURL != null) {
          final inputGroup = <String, dynamic>{
            'groupColor': 1,
            'groupCreator': currentUser!,
            'groupDesc': groupDescriptionController.text,
            'groupName': groupNameController.text,
            'groupPhotoURL': 'gs://$imageURL',
            'group_ID': "@${groupIDController.text}"
          };
          final userGroup = <String, dynamic> {
            'ID_group': "@${groupIDController.text}",
            'userEmail': currentUser!
          };
          await db.collection("groups").add(inputGroup).then((documentSnapshot) =>
              print("Added data with ID: ${documentSnapshot.id}"));
          await db.collection("groupUserList").add(userGroup).then((documentSnapshot) =>
              print("Added data with ID: ${documentSnapshot.id}"));
          Navigator.pop(context);
        }
      } catch (e) {
        print('Error uploading group: $e');
        return;
      }
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
              controller: groupNameController,
              decoration: InputDecoration(
                labelText: 'Group Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: groupDescriptionController,
              decoration: InputDecoration(
                labelText: 'Group Description',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: groupIDController,
              decoration: InputDecoration(
                labelText: '@Group ID',
                border: OutlineInputBorder(),
                prefixText: "@",
              ),
            ),
            const SizedBox(height: 16),
            // Placeholder for adding a background image
            TextButton(
              onPressed: () {
                pickImage();
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

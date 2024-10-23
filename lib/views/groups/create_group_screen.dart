import 'package:flutter/material.dart';

class CreateGroupScreen extends StatefulWidget {
  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _memberEmailController = TextEditingController();
  List<String> members = [];

  void addMember() {
    if (_memberEmailController.text.isNotEmpty) {
      setState(() {
        members.add(_memberEmailController.text);
        _memberEmailController.clear();
      });
    }
  }

  void createGroup() {
    // Handle creating the group in Firebase
    final String groupName = _groupNameController.text;

    if (groupName.isNotEmpty && members.isNotEmpty) {
      // Add the group to Firebase Firestore
      // FirebaseFirestore.instance.collection('groups').add({
      //   'name': groupName,
      //   'members': members,
      // });

      Navigator.pop(context); // Navigate back to GroupsPage
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Group'),
        backgroundColor: Colors.red,
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
            const SizedBox(height: 20),
            TextField(
              controller: _memberEmailController,
              decoration: InputDecoration(
                labelText: 'Member Email',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: addMember,
                ),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: members.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      members[index],
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          members.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: createGroup,
              child: Text('Create Group'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

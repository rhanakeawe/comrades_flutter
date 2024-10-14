import 'package:flutter/material.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  _CreateGroupScreenState createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  String groupName = '';
  Color groupColor = Colors.blue; // Default color
  List<String> members = [];
  TextEditingController memberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Group'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            const SizedBox(height: 20),
            Text('Pick a Color:'),
            Row(
              children: [
                ColorOption(color: Colors.blue, selectedColor: groupColor, onTap: () {
                  setState(() {
                    groupColor = Colors.blue;
                  });
                }),
                ColorOption(color: Colors.red, selectedColor: groupColor, onTap: () {
                  setState(() {
                    groupColor = Colors.red;
                  });
                }),
                // Add more colors as needed
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: memberController,
              decoration: const InputDecoration(
                labelText: 'Add Member',
                suffixIcon: Icon(Icons.add),
              ),
              onSubmitted: (value) {
                setState(() {
                  members.add(value);
                  memberController.clear();
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logic for saving the group and navigating back
                print('Group created: $groupName, Color: $groupColor, Members: $members');
                Navigator.pop(context);
              },
              child: const Text('Save Group'),
            ),
          ],
        ),
      ),
    );
  }
}

class ColorOption extends StatelessWidget {
  final Color color;
  final Color selectedColor;
  final VoidCallback onTap;

  const ColorOption({
    required this.color,
    required this.selectedColor,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: selectedColor == color ? Colors.black : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }
}

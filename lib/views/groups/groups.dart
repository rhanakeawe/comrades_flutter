import 'package:flutter/material.dart';
import 'package:Comrades/views/groups/create_group_screen.dart';
import 'package:getwidget/getwidget.dart';
import 'groupcard.dart';
import 'groupspage.dart';

class Groups extends StatefulWidget {
  const Groups({super.key});

  @override
  State<Groups> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<Groups> {
  List<Map<String, dynamic>> groups = [
    {
      // testers
      'name': 'Comrades',
      'description': 'The name of the app',
      'icon': Icons.people_alt,
      'backgroundImage': 'assets/Joseph-Stalin-1950.png',
    },
    {
      'name': 'Apes',
      'description': 'Together Strong!',
      'icon': Icons.people_alt,
      'backgroundImage': 'assets/planet-apes.png',
    },
    {
      'name': 'Beaners',
      'description': 'All the beans',
      'icon': Icons.people_alt,
      'backgroundImage': 'assets/Beans.png',
    },
  ];

  void addGroup(String name, String description, String? backgroundImage) {
    setState(() {
      groups.add({
        'name': name,
        'description': description,
        'icon': Icons.group,
        'backgroundImage': backgroundImage,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Groups',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CreateGroupScreen(),
                      ),
                    );
                  },
                  child: Text(
                    '+ Add Group',
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                return GroupCard(
                  name: group['name'],
                  description: group['description'],
                  icon: group['icon'],
                  backgroundImage: group['backgroundImage'],
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => GroupsPage(
                          groupName: group['name'],
                          backgroundImage: group['backgroundImage'],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

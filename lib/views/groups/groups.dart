import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:Comrades/views/groups/create_group_screen.dart';
import 'groupcard.dart';
import 'groupspage.dart';

class Groups extends StatefulWidget {
  const Groups({super.key});

  @override
  State<Groups> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<Groups> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  List<Map<String, dynamic>> groups = [];

  void getGroups() {
    db
        .collection("groupUserList")
        .where("userEmail", isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .get()
        .then(
      (groupUsers) {
        print("Successfully queried groupUser!");
        for (var groupUser in groupUsers.docs) {
          print(groupUser.data());
          db
              .collection("groups")
              .where("group_ID", isEqualTo: groupUser.data()["ID_group"])
              .get()
              .then(
            (groups) {
              print("Successfully queried group!");
              for (var group in groups.docs) {
                print(group.data());
                addGroup(group.data()["groupName"], group.data()["groupDesc"],
                    group.data()["groupPhotoURL"], group.data()["group_ID"]);
              }
            },
            onError: (e) => print("Error completing: $e"),
          );
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  Future<void> addGroup(String name, String description,
      String? backgroundImage, String groupId) async {
    final gsReference = FirebaseStorage.instance.refFromURL(backgroundImage!);
    String url = await gsReference.getDownloadURL();

    setState(() {
      groups.add({
        'name': name,
        'description': description,
        'icon': Icons.group,
        'backgroundImage': url,
        'group_ID': groupId,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (groups.isEmpty) {
      getGroups();
    }
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
                  backgroundImage: group['backgroundImage'],
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => GroupsPage(
                          groupName: group['name'],
                          groupID: group['group_ID'],
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

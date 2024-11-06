import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:Comrades/views/groups/create_group_screen.dart';
import '../../querylist.dart';
import 'groupcard.dart';
import 'groupspage.dart';

class Groups extends StatefulWidget {
  const Groups({super.key});

  @override
  State<Groups> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<Groups> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final QueryList _queryList = QueryList();
  List<Map<String, dynamic>> groups = [];

  @override
  void initState() {
    super.initState();
    getGroups();
  }

  Future<void> getGroups() async {
    if (groups.isNotEmpty) {
      groups.clear();
    }
    try {
      QuerySnapshot<Map<String, dynamic>> groupUserSnapshot =
          await _queryList.fetchList("groupUserList", "userEmail", FirebaseAuth.instance.currentUser!.email.toString());
      for (var groupUser in groupUserSnapshot.docs) {
        QuerySnapshot<Map<String, dynamic>> groupSnapshot =
        await _queryList.fetchList("groups", "group_ID", groupUser.data()["ID_group"]);
        for (var group in groupSnapshot.docs) {
          print(group.data());
          addGroup(group.data()["groupName"], group.data()["groupDesc"],
              group.data()["groupPhotoURL"], group.data()["group_ID"]);
        }
      }
    } catch (e) {}
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
            child: RefreshIndicator(
              onRefresh: getGroups,
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
          ),
        ],
      ),
    );
  }
}

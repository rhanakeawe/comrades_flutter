import 'package:Comrades/data/groupData.dart';
import 'package:Comrades/data/manageCache.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:Comrades/views/groups/create_group_screen.dart';
import '../../querylist.dart';
import 'groupcard.dart';
import 'groupspage.dart';
import '../../notification/notification.dart';


class Groups extends StatefulWidget {
  const Groups({super.key});

  @override
  State<Groups> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<Groups> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final QueryList _queryList = QueryList();
  List<Map<String, dynamic>> groupsList = [];

  @override
  void initState() {
    super.initState();
    getGroups();
  }

  Future<void> refreshGroups() async {
    final manageCache = ManageCache();
    await manageCache.deleteCache('groups_data.json');
    groupsList.clear();
    getGroups();
    NotificationService.showInstantNotification("Refreshed Groups", "Groups list has been refreshed!");
  }

  Future<void> getGroups() async {
    final manageCache = ManageCache();
    var loadedGroups =
        await manageCache.loadListFromCache('groups_data.json');

    if (loadedGroups == null) {
      List<GroupData> groups = [];
      try {
        QuerySnapshot<Map<String, dynamic>> groupUserSnapshot =
            await _queryList.fetchList("groupUserList", "userEmail",
                FirebaseAuth.instance.currentUser!.email.toString());
        for (var groupUser in groupUserSnapshot.docs) {
          QuerySnapshot<Map<String, dynamic>> groupSnapshot = await _queryList
              .fetchList("groups", "group_ID", groupUser.data()["ID_group"]);
          for (var group in groupSnapshot.docs) {
            print(group.data());
            final gsReference = FirebaseStorage.instance
                .refFromURL(group.data()["groupPhotoURL"]!);
            String url = await gsReference.getDownloadURL();
            setState(() {
              groups.add(GroupData(
                  groupName: group.data()["groupName"],
                  group_ID: group.data()["group_ID"],
                  groupCreator: group.data()["groupCreator"],
                  groupDesc: group.data()["groupDesc"],
                  groupPhotoURL: url,
                  groupColor: group.data()["groupColor"].toString()));
            });
          }
        }
        await manageCache.saveListToCache('groups_data.json', groups);
        for (var group in groups) {
          setState(() {
            groupsList.add({
              "name": group.groupName,
              "description": group.groupDesc,
              "backgroundImage": group.groupPhotoURL,
              "group_ID": group.group_ID,
            });
          });
        }
      } catch (e) {
        print("Error getting groups: $e");
      }
    } else {
      loadedGroups = loadedGroups as List<GroupData>;
      for (var group in loadedGroups) {
        setState(() {
          groupsList.add({
            "name": group.groupName,
            "description": group.groupDesc,
            "backgroundImage": group.groupPhotoURL,
            "group_ID": group.group_ID,
          });
        });
      }
    }
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
              onRefresh: refreshGroups,
              child: ListView.builder(
                itemCount: groupsList.length,
                itemBuilder: (context, index) {
                  final group = groupsList[index];
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

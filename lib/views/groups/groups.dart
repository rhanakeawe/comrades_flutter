import 'dart:async';

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

  @override
  Widget build(BuildContext context) {
    bool doNotNotif = true;
    final String? userEmail = FirebaseAuth.instance.currentUser?.email;
    final groupUserListStream = db
        .collection('groupUserList')
        .where('userEmail', isEqualTo: userEmail)
        .snapshots();

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
              child: StreamBuilder(
                  stream: groupUserListStream,
                  builder: (context, groupUserListSnapshot) {
                    if (groupUserListSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (doNotNotif == false) {
                      for (var changes in groupUserListSnapshot.data!.docChanges) {
                        switch (changes.type) {
                          case DocumentChangeType.added:
                            NotificationService.showInstantNotification("Added Group", "${changes.doc.data()?["ID_group"]} Added to List!");
                          case DocumentChangeType.modified:
                            NotificationService.showInstantNotification("Modified Group", "${changes.doc.data()?["ID_group"]} Modified in List!");
                          case DocumentChangeType.removed:
                            NotificationService.showInstantNotification("Removed Group", "${changes.doc.data()?["ID_group"]} Removed from List!");
                        }
                      }
                    }
                    final groupIDs = groupUserListSnapshot.data?.docs
                        .map((doc) => doc['ID_group'] as String)
                        .toList();
                    final groupsStream = db
                        .collection('groups')
                        .where("group_ID", whereIn: groupIDs)
                        .snapshots();
                    return StreamBuilder<QuerySnapshot>(
                        stream: groupsStream,
                        builder: (context, groupsSnapshot) {
                          if (groupsSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          final groups = groupsSnapshot.data?.docs.map((doc) {
                            final data = doc.data() as Map<String, dynamic>;
                            return {
                              'name': data['groupName'],
                              'description': data['groupDesc'],
                              'backgroundImage': data['groupPhotoURL'],
                              'group_ID': data["group_ID"]
                            };
                          }).toList();
                          doNotNotif = false;
                          print(doNotNotif);
                          return ListView.builder(
                              itemCount: groups?.length,
                              itemBuilder: (context, index) {
                                final group = groups?[index];
                                return FutureBuilder<String?>(
                                    future: FirebaseStorage.instance
                                        .refFromURL(group?['backgroundImage'])
                                        .getDownloadURL(),
                                    builder: (context, imageSnapshot) {
                                      final imageUrl = imageSnapshot.data;
                                      return GestureDetector(
                                        onTapDown: (TapDownDetails details) async {
                                          Offset offset = details.globalPosition;
                                          final left = offset.dx;
                                          final top = offset.dy;
                                          await showMenu(
                                            context: context,
                                            position: RelativeRect.fromLTRB(left, top, 100, 100),
                                            items: [
                                              const PopupMenuItem(
                                                value: "Delete",
                                                child: Text('Delete'),
                                              )]
                                          ).then((value) async {
                                            switch (value) {
                                              case "Delete": {
                                                try {
                                                  QuerySnapshot<Map<String, dynamic>>
                                                  groupUserListSnapshot =
                                                      await _queryList.fetchList(
                                                      "groupUserList",
                                                      "ID_group",
                                                      group?["group_ID"],
                                                      "userEmail",
                                                      FirebaseAuth.instance
                                                          .currentUser!.email
                                                          .toString());
                                                  for (var groupUser
                                                  in groupUserListSnapshot.docs) {
                                                    print(groupUser.data());
                                                    db.collection("groupUserList")
                                                        .doc(groupUser.id)
                                                        .delete();}
                                                } catch (e) {
                                                  print("Error deleting groupUser: $e");}
                                                break;
                                              }}});},
                                        child: GroupCard(
                                          name: group?['name'],
                                          description: group?['description'],
                                          backgroundImage: imageUrl ?? "",
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    GroupsPage(
                                                  groupName: group?['name'],
                                                  groupID: group?['group_ID'],
                                                  backgroundImage:
                                                      imageUrl ?? "",
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    });
                                });
                          });
                  })
          ),
        ],
      ),
    );
  }
}

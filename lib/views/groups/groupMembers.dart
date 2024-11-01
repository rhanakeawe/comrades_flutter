import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';

class GroupMembersPage extends StatefulWidget {
  final String groupID;

  const GroupMembersPage({
    super.key,
    required this.groupID,
  });

  @override
  State<GroupMembersPage> createState() => _GroupMembersPageState();
}

class _GroupMembersPageState extends State<GroupMembersPage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<Map<String, dynamic>> members = [];

  void getMembers(String groupID) {
    db
        .collection("groupUserList")
        .where("ID_group", isEqualTo: groupID)
        .get()
        .then(
      (groupUsers) {
        print("Successfully queried group!");
        for (var groupUser in groupUsers.docs) {
          print(groupUser.data());
          addUser(groupUser.data()["userEmail"]);
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  Future<void> addUser(String userEmail) async {
    db.collection("users").where("email", isEqualTo: userEmail).get().then(
      (users) {
        print("Successfully queried user!");
        for (var user in users.docs) {
          print(user.data());
          setState(() {
            members.add({
            'name': user.data()["name"],
            'photo': user.data()["profilepic"]
            });
          });
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) {
      getMembers(widget.groupID);
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey,
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(height: 10),
        Expanded(
            child: ListView.builder(
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  print(member);
                  return GFListTile(
                    titleText: member['name'],
                    color: Colors.white,
                    avatar: GFAvatar(
                      backgroundImage: NetworkImage(member['photo']!),
                    ),
                  );
                }))
      ]),
    );
  }
}

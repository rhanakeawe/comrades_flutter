import 'package:Comrades/views/groups/page/groupAddMember.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:Comrades/querylist.dart';

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
  final QueryList _queryList = QueryList();
  List<Map<String, dynamic>> members = [];

  @override
  void initState() {
    super.initState();
    getMembers(widget.groupID);
  }

  Future<void> getMembers(String groupID) async {
    try {
      // Fetch group users based on group ID
      QuerySnapshot<Map<String, dynamic>> groupUsersSnapshot =
          await _queryList.fetchList(
        "groupUserList",
        "ID_group",
        groupID,
      );

      for (var groupUser in groupUsersSnapshot.docs) {
        await addUser(groupUser.data()["userEmail"]);
      }
    } catch (e) {}
  }

  Future<void> addUser(String userEmail) async {
    try {
      // Fetch user based on email
      QuerySnapshot<Map<String, dynamic>> userSnapshot =
          await _queryList.fetchList(
        "users",
        "email",
        userEmail,
      );

      for (var user in userSnapshot.docs) {
        setState(() {
          members.add({
            'name': user.data()["name"],
            'photo': user.data()["profilepic"],
            'email': user.data()["email"]
          });
        });
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text(
          "Members",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(height: 10),
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
                      builder: (context) => GroupAddMember(
                        groupID: widget.groupID,
                        members: members,
                      ),
                    ),
                  );
                },
                child: Text(
                  '+ Add Member',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
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

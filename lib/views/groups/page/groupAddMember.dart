import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/avatar/gf_avatar.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/components/search_bar/gf_search_bar.dart';

class GroupAddMember extends StatefulWidget {
  final String groupID;
  final List<Map<String, dynamic>> members;

  const GroupAddMember(
      {super.key, required this.groupID, required this.members});

  @override
  State<GroupAddMember> createState() => _GroupAddMemberState();
}

class _GroupAddMemberState extends State<GroupAddMember> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<Map<String, dynamic>> userList = [];
  List userNames = [];

  @override
  void initState() {
    super.initState();
    findUsers();
  }

  void findUsers() {
    db.collection("users").get().then(
      (users) {
        print("Successfully queried user!");
        for (var user in users.docs) {
          //print(user.data());
          setState(() {
            userList.add({
              'name': user.data()["name"],
              'photo': user.data()["profilepic"],
              'email': user.data()["email"]
            });
          });
        }
        for (var member in widget.members) {
          userList.removeWhere((i) => i["email"] == member['email']);
          print("removed ${member['email']}");
        }
        for (var user in userList) {
          userNames.add(user['name']);
        }
      },
      onError: (e) => print("Error completing: $e"),
    );
    print(userNames);
  }

  void addUser(String name) {
    Map<String, dynamic> item = {'name': name};
    final index = userList.indexWhere((i) => i['name'] == item['name']);
    String email = userList[index]['email'];

    final user = <String, String>{
      "userEmail": email,
      "ID_group": widget.groupID
    };

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Added ${user['userEmail']}")));

    db.collection("groupUserList").add(user).then((documentSnapshot) =>
        print("Added Data with ID: ${documentSnapshot.id}"));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          GFSearchBar(
            searchList: userNames,
            searchQueryBuilder: (query, userNames) {
              return userNames
                  .where((item) =>
                      item.toLowerCase().contains(query.toLowerCase()))
                  .toList();
            },
            overlaySearchListItemBuilder: (item) {
              return Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  item,
                  style: const TextStyle(fontSize: 18),
                ),
              );
            },
            onItemSelected: (item) {
              addUser(item);
            },
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: userList.length,
                  itemBuilder: (context, index) {
                    final member = userList[index];
                    return GFListTile(
                      titleText: member['name'],
                      color: Colors.white,
                      avatar: GFAvatar(
                        backgroundImage: NetworkImage(member['photo']!),
                      ),
                      onTap: () => addUser(member['name']),
                    );
                  }))
        ],
      ),
    );
  }
}

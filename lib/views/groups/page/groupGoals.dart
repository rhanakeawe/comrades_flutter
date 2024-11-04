import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Comrades/querylist.dart';

class GroupGoalsPage extends StatefulWidget {
  final String groupID;

  const GroupGoalsPage({
    super.key,
    required this.groupID,
  });

  @override
  State<GroupGoalsPage> createState() => _GroupGoalsPageState();
}

class _GroupGoalsPageState extends State<GroupGoalsPage> {
  final QueryList _queryList = QueryList();

  @override
  void initState() {
    super.initState();
    getGoals();
  }

  List<Map<String, dynamic>> goals = [];

  Future<void> getGoals() async {
    try {
      // Fetch group users based on group ID
      QuerySnapshot<Map<String, dynamic>> groupUsersSnapshot =
      await _queryList.fetchList(
        "goals",
        "ID_group",
        widget.groupID,
      );

      for (var goal in groupUsersSnapshot.docs) {
        print(goal.data());
        setState(() {
          goals.add({
            'dayCount': goal.data()["goalDayCount"],
            'dayStart': goal.data()["goalDayStart"],
            'name': goal.data()["goalName"],
            'text': goal.data()["goalText"],
            'email': goal.data()["userEmail"],
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
        title: Text("Goals", style: TextStyle(fontSize: 20, color: Colors.white),),
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
          Expanded(
              child: ListView.builder(
                  itemCount: goals.length,
                  itemBuilder: (context, index) {
                    final goal = goals[index];
                    return GFListTile(
                      title: Center(
                        child: Column(
                          children: [
                            Text(goal['name'], style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700)),
                            Text(goal['email'], style: GoogleFonts.poppins(fontSize: 13, fontStyle: FontStyle.italic)),
                            Text(goal['text'], style: GoogleFonts.poppins(fontSize: 15)),
                          ],
                        ),
                      ),
                      description: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(goal['dayCount'], style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700)),
                                    Text("Days left", style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(goal['dayStart'], style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w700)),
                                    Text("Started", style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      color: Colors.greenAccent,
                    );
                  }))
        ],
      ),
    );
  }
}
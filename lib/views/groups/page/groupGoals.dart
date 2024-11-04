import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:google_fonts/google_fonts.dart';

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

  List<Map<String, dynamic>> goals = [
    {
      'dayCount': "10",
      'dayStart': "12/02/1000",
      'name': "First Goal",
      'text': "This is the first goal of many!",
      'userEmail': 'rhanakeawe@gmail.com'
    },
    {
      'dayCount': "12",
      'dayStart': "2/02/1002",
      'name': "Second Goal",
      'text': "This is the second goal of many!",
      'userEmail': 'example@gmail.com'
    }
  ];

  QuerySnapshot<Map<String, dynamic>> queryList(String collection, String field, String value){
    QuerySnapshot<Map<String, dynamic>> output = [] as QuerySnapshot<Map<String, dynamic>>;
    return output;
  }

  void getGoals() {
    var goalQueryList = queryList("goals", "ID_group", widget.groupID);
    for (var goal in goalQueryList.docs) {
      print(goal.data());
      setState(() {
        goals.add({
          'dayCount': goal.data()["goalDayCount"],
          'dayStart': goal.data()["goalDayStart"],
          'name': goal.data()["goalName"],
          'text': goal.data()["goalText"]
        });
      });
    }
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
                      title: Text(goal['name'], style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700)),
                      subTitle: Text(goal['text'], style: GoogleFonts.poppins(fontSize: 15)),
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
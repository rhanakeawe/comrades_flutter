import 'package:Comrades/data/manageCache.dart';
import 'package:Comrades/querylist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/goalData.dart';
import 'addGoal.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({super.key});

  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  final QueryList _queryList = QueryList();
  FirebaseFirestore db = FirebaseFirestore.instance;
  var currentUser = FirebaseAuth.instance.currentUser?.email;
  List<Map<String, dynamic>> goalsList = [];

  @override
  void initState() {
    super.initState();
    getGoals();
  }

  Future<void> refreshGoals() async {
    print("refresh goals");
    final manageCache = ManageCache();
    await manageCache.deleteCache('goals_data.json');
    goalsList.clear();
    getGoals();
  }

  Future<void> getGoals() async {
    print("get goals");
    final manageCache = ManageCache();
    var loadedGoals = await manageCache.loadListFromCache('goals_data.json');

    if (loadedGoals == null) {
      List<GoalData> goals = [];
      try {
        // Fetch group users based on group ID
        QuerySnapshot<Map<String, dynamic>> goalUsersSnapshot =
        await _queryList.fetchList(
          "goals",
          "userEmail",
          currentUser!,
        );
        for (var goal in goalUsersSnapshot.docs) {
          DateTime? dayStart = DateTime.tryParse(goal.data()["goalDayStart"].toDate().toString());
          DateTime? dayEnd = DateTime.tryParse(goal.data()["goalDayEnd"].toDate().toString());
          print("dayStart: ${dayStart}");
          setState(() {
            goals.add(GoalData(
                goalName: goal.data()["goalName"],
                goalText: goal.data()["goalText"],
                userEmail: goal.data()["userEmail"],
                goalDayStart: dayStart.toString(),
                goalDayEnd: dayEnd.toString(),
                ID_group: goal.data()["ID_group"]));
          });
        }
        await manageCache.saveListToCache('goals_data.json', goals);
        for (var goal in goals) {
          DateTime? dayStart = DateTime.tryParse(goal.goalDayStart);
          DateTime? dayEnd = DateTime.tryParse(goal.goalDayEnd);
          final dayCount = dayEnd!.difference(DateTime.now()).inDays;
          setState(() {
            goalsList.add({
              "name": goal.goalName,
              "email": goal.userEmail,
              "text": goal.goalText,
              "dayStart": "${dayStart!.month}/${dayStart.day}/${dayStart.year}",
              "dayCount": dayCount.toString(),
            });
          });
          print(goalsList.length);
        }
      } catch (e) {
        print(e);
      }
    } else {
      print("loaded goals");
      loadedGoals = loadedGoals as List<GoalData>;
      for (var goal in loadedGoals) {
        DateTime? dayStart = DateTime.tryParse(goal.goalDayStart);
        DateTime? dayEnd = DateTime.tryParse(goal.goalDayEnd);
        final dayCount = dayEnd!.difference(DateTime.now()).inDays;
        setState(() {
          goalsList.add({
            "name": goal.goalName,
            "email": goal.userEmail,
            "text": goal.goalText,
            "dayStart": "${dayStart!.month}/${dayStart.day}/${dayStart.year}",
            "dayCount": dayCount.toString(),
          });
          print(goalsList);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          height: 16,
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddGoal(goals: goalsList),
              ),
            );
          },
          child: Text(
            '+ Add Goal',
            style: TextStyle(
              color: Colors.blueAccent,
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(height: 10,),
        Expanded(
            child: RefreshIndicator(
              onRefresh: refreshGoals,
              child: ListView.builder(
                  itemCount: goalsList.length,
                  itemBuilder: (context, index) {
                    final goal = goalsList[index];
                    return GFListTile(
                      title: Center(
                        child: Column(
                          children: [
                            Text(goal['name'],
                                style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white)),
                            Text(goal['email'],
                                style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.white)),
                            Text(goal['text'],
                                style: GoogleFonts.poppins(
                                    fontSize: 15, color: Colors.white)),
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
                                    Text(goal['dayCount'],
                                        style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white)),
                                    Text("Days left",
                                        style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(goal['dayStart'],
                                        style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white)),
                                    Text("Started",
                                        style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      color: Colors.lightBlue,
                    );
                  }),
            ))
      ],
    ));
  }
}

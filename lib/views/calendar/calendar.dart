import 'package:Comrades/querylist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final QueryList _queryList = QueryList();
  FirebaseFirestore db = FirebaseFirestore.instance;
  var currentUser = FirebaseAuth.instance.currentUser?.email;
  List<Map<String,dynamic>> goals = [];

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getGoals();
    super.initState();
  }

  Future<void> getGoals() async {
    if (goals.isNotEmpty) {
      goals.clear();
    }
    try {
      // Fetch group users based on group ID
      QuerySnapshot<Map<String, dynamic>> groupUsersSnapshot =
          await _queryList.fetchList(
        "goals",
        "userEmail",
        currentUser!,
      );

      for (var goal in groupUsersSnapshot.docs) {
        print(goal.data());
        Timestamp dayEndTS = goal.data()["goalDayEnd"];
        DateTime? dayEnd = DateTime.tryParse(dayEndTS.toDate().toString());
        goals.add({
          'dayEnd': dayEnd,
          'name': goal.data()["goalName"],
          'text': goal.data()["goalText"],
        });
      }
    } catch (e) {}
  }

  List<Map<String, dynamic>> getGoalFromDay (DateTime day) {
    List<Map<String,DateTime>> goalsFromDay = [];
    for (var goal in goals) {
      if (goal['dayEnd'].day == day.day) {
        goalsFromDay.add(goal);
      }
    }
    print("!/${goalsFromDay.length}");
    return goalsFromDay;
  }

  late final ValueNotifier<List<DateTime>> _selectedEvents;
  DateTime _focusedDay = DateTime.now();
  var _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TableCalendar(
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) {
                    return (_selectedDay == day);
                  },
                  firstDay: DateTime(1900, 1, 1),
                  lastDay: DateTime(3000, 1, 1),
                  onDaySelected: (selectedDay, focusedDay) {
                    if (selectedDay != _selectedDay) {
                      setState(() {
                        print("Day selected");
                        _focusedDay = focusedDay;
                        _selectedDay = selectedDay;
                      });
                    }
                  },
                  eventLoader: (day) {
                    List<DateTime> dayGoals = [];
                    for (var goal in goals) {
                      print("Goal found: ${goal}");
                      if (goal['dayEnd'].day == day.day){
                        dayGoals.add(goal['dayEnd']);
                      }
                    }
                    return dayGoals;
                  },
                ),
                ListView.builder(itemCount: getGoalFromDay(_selectedDay).length,itemBuilder: (context, index) {
                  final goal = getGoalFromDay(_selectedDay)[index];
                  return GFListTile(
                    title: Text(goal['name']),
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}

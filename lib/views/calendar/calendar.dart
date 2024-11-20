import 'package:Comrades/querylist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:google_fonts/google_fonts.dart';
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
  List<Map<String, dynamic>> goals = [];
  List<Map<String, dynamic>> currentGoals = [];
  late final ValueNotifier<List<DateTime>> _selectedEvents;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getGoals();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
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

  List<DateTime> _getEventsForDay(DateTime day) {
    List<DateTime> goalsFromDay = [];
    if (currentGoals.isNotEmpty) {
      currentGoals.clear();
    }
    for (var goal in goals) {
      if (isSameDay(goal['dayEnd'], day)) {
        currentGoals.add(goal);
        goalsFromDay.add(day);
      }
    }
    return goalsFromDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: getGoals,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TableCalendar<DateTime>(
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => (isSameDay(_selectedDay, day)),
                  firstDay: DateTime(1900, 1, 1),
                  lastDay: DateTime(3000, 1, 1),
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(selectedDay, _selectedDay)) {
                      setState(() {
                        _focusedDay = focusedDay;
                        _selectedDay = selectedDay;
                      });
                    _selectedEvents.value = _getEventsForDay(selectedDay);
                    }
                  },
                  eventLoader: _getEventsForDay,
                ),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ValueListenableBuilder<List<DateTime>>(
                      valueListenable: _selectedEvents,
                      builder: (context, value, _) {
                        return ListView.builder(
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            final currentGoal = currentGoals[index];
                            return GFListTile(
                              color: Colors.lightBlue,
                              title: Text(currentGoal['name'],
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white
                              ),),
                              subTitle: Text(currentGoal['text'],
                                style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  color: Colors.white
                                ),),
                            );
                          },
                        );
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

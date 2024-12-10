import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'days_of_the_week.dart';
import 'week_view.dart';
import 'month_view.dart';
import 'placeholder_message.dart';
import 'add_event.dart';
import 'package:Comrades/data/event.dart';
import 'package:Comrades/data/groupData.dart';
import 'package:Comrades/components/availability_utils.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  bool _isMonthView = false;

  final List<Event> _events = [];
  final List<Map<String, DateTime>> _unavailabilityList = [];
  List<Map<String, dynamic>> _groupAvailability = [];

  bool _isAvailable(DateTime startTime, DateTime endTime) {
    return AvailabilityUtils.isAvailable(
        startTime, endTime, _unavailabilityList);
  }

  Future<void> _addUnavailabilityToFirestore(
      DateTime startTime, DateTime endTime, String groupID) async {
    await FirebaseFirestore.instance.collection('groupUnavailability').add({
      'ID_group': groupID,
      'startTime': startTime,
      'endTime': endTime,
    });
  }

  Future<List<Map<String, dynamic>>> _getGroupAvailabilityForDay() async {
    final groupUserListSnapshot = await FirebaseFirestore.instance
        .collection('groupUserList')
        .where('userEmail', isEqualTo: FirebaseAuth.instance.currentUser?.email)
        .get();

    final groupIDs =
        groupUserListSnapshot.docs.map((doc) => doc['ID_group']).toList();

    final groupsSnapshot = await FirebaseFirestore.instance
        .collection('groups')
        .where('group_ID', whereIn: groupIDs)
        .get();

    List<GroupData> groups = groupsSnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return GroupData.fromJson(data);
    }).toList();

    List<List<Map<String, DateTime>>> groupUnavailabilityLists = [];
    for (var group in groups) {
      final unavailabilitySnapshot = await FirebaseFirestore.instance
          .collection('groupUnavailability')
          .where('ID_group', isEqualTo: group.group_ID)
          .get();

      List<Map<String, DateTime>> unavailability =
          unavailabilitySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'startTime': (data['startTime'] as Timestamp).toDate(),
          'endTime': (data['endTime'] as Timestamp).toDate(),
        };
      }).toList();

      groupUnavailabilityLists.add(unavailability);
    }

    DateTime dayStart =
        DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day, 0, 0);
    DateTime dayEnd = DateTime(
        _selectedDay.year, _selectedDay.month, _selectedDay.day, 23, 59);

    List<Map<String, dynamic>> calculatedAvailability = [];
    for (int i = 0; i < groups.length; i++) {
      List<Map<String, DateTime>> availability =
          AvailabilityUtils.getGroupAvailability(
        [groupUnavailabilityLists[i]],
        dayStart,
        dayEnd,
      );

      for (var slot in availability) {
        calculatedAvailability.add({
          'groupName': groups[i].groupName,
          'startTime': slot['startTime'],
          'endTime': slot['endTime'],
        });
      }
    }

    return calculatedAvailability;
  }

  void _fetchAndSetGroupAvailability() async {
    final availability = await _getGroupAvailabilityForDay();
    setState(() {
      _groupAvailability = availability;
    });
  }

  Widget _buildGroupAvailabilityWidget() {
    if (_groupAvailability.isEmpty) {
      return const PlaceholderMessage(
        message: "No overlapping availability found for the selected day.",
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _groupAvailability.length,
      itemBuilder: (context, index) {
        final availability = _groupAvailability[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green.shade700,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "${availability['groupName']} - Available: ${DateFormat.jm().format(availability['startTime']!)} - ${DateFormat.jm().format(availability['endTime']!)}",
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchAndSetGroupAvailability();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        toolbarHeight: 80,
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.y().format(_focusedDay),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Row(
                children: [
                  Text(
                    DateFormat.MMMM().format(_focusedDay),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isMonthView
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _isMonthView = !_isMonthView;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              setState(() {
                _focusedDay = DateTime.now();
                _selectedDay = DateTime.now();
              });
            },
            child: CircleAvatar(
              backgroundColor: Colors.blue.shade700,
              child: Text(
                DateFormat.d().format(DateTime.now()),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AddEventWidget(
                    onAddEvent: (title, startTime, endTime) {
                      setState(() {
                        _events.add(
                          Event(
                            title: title,
                            startTime: startTime,
                            endTime: endTime,
                            participants: [],
                            isPersonal: false,
                          ),
                        );
                      });
                    },
                    onAddUnavailability: (startTime, endTime) {
                      final groupID =
                          'personal'; // Replace with actual group ID if needed
                      _addUnavailabilityToFirestore(
                          startTime, endTime, groupID);
                      setState(() {
                        _unavailabilityList.add({
                          'startTime': startTime,
                          'endTime': endTime,
                        });
                      });
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          DaysOfWeek(highlightCurrentDay: true),
          const Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          _isMonthView
              ? MonthView(
                  focusedDay: _focusedDay,
                  selectedDay: _selectedDay,
                  onDaySelected: (day) {
                    setState(() {
                      _selectedDay = day;
                    });
                    _fetchAndSetGroupAvailability();
                  },
                )
              : WeekView(
                  focusedDay: _focusedDay,
                  selectedDay: _selectedDay,
                  events: _events,
                  onDaySelected: (day) {
                    setState(() {
                      _selectedDay = day;
                    });
                    _fetchAndSetGroupAvailability();
                  },
                ),
          const SizedBox(height: 16),
          _buildGroupAvailabilityWidget(),
        ],
      ),
    );
  }
}

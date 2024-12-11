import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'days_of_the_week.dart';
import 'week_view.dart';
import 'month_view.dart';
import 'placeholder_message.dart';
import 'add_event.dart';
import 'group_avail.dart'; // GroupAvailabilityWidget
import 'package:Comrades/data/event.dart';
import 'package:Comrades/data/avail_service.dart';
import 'package:Comrades/data/groupData.dart';
import 'package:Comrades/components/availability_utils.dart';
import 'event_view.dart'; // Import the EventView widget

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  CalendarPageState createState() => CalendarPageState();
}

class CalendarPageState extends State<CalendarPage> {
  final AvailabilityService _availabilityService = AvailabilityService();

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  bool _isMonthView = false;

  List<Event> _events = []; // List<Event> for events
  List<Map<String, dynamic>> _groupAvailability = [];
  List<Map<String, dynamic>> _userEvents = []; // Store user events

  @override
  void initState() {
    super.initState();

    // Manually adding events for testing purposes
    _events = [
      Event(
        title: 'Study',
        startTime: DateTime(2024, 12, 9, 10, 0),
        endTime: DateTime(2024, 12, 9, 20, 0),
        participants: [],
        isPersonal: false,
      ),
      Event(
        title: 'School',
        startTime: DateTime(2024, 12, 10, 9, 0),
        endTime: DateTime(2024, 12, 10, 17, 0),
        participants: [],
        isPersonal: false,
      ),
      Event(
        title: 'School',
        startTime: DateTime(2024, 12, 13, 9, 0),
        endTime: DateTime(2024, 12, 13, 17, 0),
        participants: [],
        isPersonal: false,
      ),
      Event(
        title: 'Study',
        startTime: DateTime(2024, 12, 15, 17, 0),
        endTime: DateTime(2024, 12, 15, 20, 0),
        participants: [],
        isPersonal: false,
      ),
      Event(
        title: 'Date',
        startTime: DateTime(2024, 12, 16, 19, 0),
        endTime: DateTime(2024, 12, 16, 22, 0),
        participants: [],
        isPersonal: false,
      ),
      Event(
        title: 'Cry',
        startTime: DateTime(2024, 12, 17, 8, 0),
        endTime: DateTime(2024, 12, 17, 22, 0),
        participants: [],
        isPersonal: false,
      ),
    ];

    // Manually adding group availability for testing purposes
    _groupAvailability = [
      {
        'groupName': 'Comrades',
        'startTime': DateTime(2024, 12, 9, 20, 0),
        'endTime': DateTime(2024, 12, 9, 22, 0),
      },
      {
        'groupName': 'Beaners',
        'startTime': DateTime(2024, 12, 10, 17, 0),
        'endTime': DateTime(2024, 12, 10, 22, 0),
      },
      {
        'groupName': 'Grass Party',
        'startTime': DateTime(2024, 12, 13, 17, 0),
        'endTime': DateTime(2024, 12, 13, 22, 0),
      },
      {
        'groupName': 'Comrades',
        'startTime': DateTime(2024, 12, 12, 17, 0),
        'endTime': DateTime(2024, 12, 12, 19, 0),
      },
      {
        'groupName': 'Testers',
        'startTime': DateTime(2024, 12, 11, 17, 0),
        'endTime': DateTime(2024, 12, 11, 22, 0),
      },
    ];

    // Simulating fetch
    _fetchAndSetGroupAvailability();
  }

  Future<void> _fetchAndSetGroupAvailability() async {
    // Simulated fetch function to mimic fetching data
    final userEmail = FirebaseAuth.instance.currentUser?.email;

    if (userEmail != null) {
      setState(() {
        _groupAvailability = _groupAvailability; // Using predefined group availability
        _userEvents = _userEvents; // Using predefined user events
      });
    } else {
      print("Error: User email is null.");
    }
  }

  Widget _buildGroupAvailabilityWidget() {
    if (_groupAvailability.isEmpty && _userEvents.isEmpty) {
      return const Center(
        child: PlaceholderMessage(
          message: "No availability or events found for the selected day.",
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GroupAvailabilityWidget(
        groupAvailability: _groupAvailability,
        userEvents: _userEvents,
      ),
    );
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
                      // Add unavailability if needed
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      body: ListView(
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
            availableDates: _convertGroupAvailabilityToDateTime(_groupAvailability), // Pass converted available dates
            groupAvailability: _groupAvailability,
            userEvents: _convertEventsToMap(_events),
          )
              : WeekView(
            focusedDay: _focusedDay,
            selectedDay: _selectedDay,
            events: _convertEventsToMap(_events),
            onDaySelected: (day) {
              setState(() {
                _selectedDay = day;
              });
              _fetchAndSetGroupAvailability();
            },
          ),
          const SizedBox(height: 16),
          _buildGroupAvailabilityWidget(),
          const SizedBox(height: 16),
          // Only display events for the selected day
          ..._getEventsForSelectedDay().map((event) => EventView(
            title: event.title,
            startTime: event.startTime,
            endTime: event.endTime,
          )).toList(),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _convertGroupAvailabilityToDateTime(List<Map<String, dynamic>> groupAvailability) {
    return groupAvailability.map((availability) {
      return {
        'startTime': availability['startTime'],
        'endTime': availability['endTime'],
      };
    }).toList();
  }

  // Convert events (List<Event>) to List<Map<String, dynamic>>
  List<Map<String, dynamic>> _convertEventsToMap(List<Event> events) {
    return events.map((event) {
      return {
        'eventTitle': event.title,
        'startTime': event.startTime, // DateTime directly
        'endTime': event.endTime,     // DateTime directly
        'participants': event.participants,
        'isPersonal': event.isPersonal,
      };
    }).toList();
  }

  // Get events for the selected day
  List<Event> _getEventsForSelectedDay() {
    return _events.where((event) {
      final eventDate = DateTime(event.startTime.year, event.startTime.month, event.startTime.day);
      return eventDate.isAtSameMomentAs(_selectedDay);
    }).toList();
  }

  List<DateTime> _getAvailableDates() {
    return _groupAvailability
        .map((availability) => availability['startTime'])
        .whereType<DateTime>()
        .toList();
  }
}

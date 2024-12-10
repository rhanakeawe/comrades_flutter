import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'days_of_the_week.dart';
import 'week_view.dart';
import 'month_view.dart';
import 'placeholder_message.dart';
import 'add_event.dart';
import 'group_avail.dart';
import 'package:Comrades/data/event.dart';
import 'package:Comrades/data/avail_service.dart';
import 'package:Comrades/data/groupData.dart';
import 'package:Comrades/components/availability_utils.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final AvailabilityService _availabilityService = AvailabilityService();

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  bool _isMonthView = false;

  final List<Event> _events = [];
  List<Map<String, dynamic>> _groupAvailability = [];

  Future<void> _fetchAndSetGroupAvailability() async {
    final userEmail = FirebaseAuth.instance.currentUser?.email;
    if (userEmail != null) {
      try {
        // Fetch availability from the service
        final availability = await _availabilityService.getGroupAvailabilityForDay(
          userEmail,
          _selectedDay,
        );

        print("Fetched Group Availability: $availability"); // Debugging

        setState(() {
          _groupAvailability = availability;
        });
      } catch (e) {
        print("Error fetching group availability: $e");
      }
    }
  }

  Widget _buildGroupAvailabilityWidget() {
    if (_groupAvailability.isEmpty) {
      return const PlaceholderMessage(
        message: "No overlapping availability found for the selected day.",
      );
    }

    return GroupAvailabilityWidget(
      groupAvailability: _groupAvailability,
    ); // Use widget for group availability display
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
                      // Add unavailability here if needed
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

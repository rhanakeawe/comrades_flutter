import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'days_of_the_week.dart';
import 'week_view.dart';
import 'month_view.dart';
import 'placeholder_message.dart';
import 'add_event.dart'; // Import the AddEventWidget
import 'package:Comrades/data/event.dart'; // Import your Event model

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  bool _isMonthView = false;

  // Events list to store events
  final List<Event> _events = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        toolbarHeight: 80, // Adjusted height for proper spacing
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0), // Adjusted padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.y().format(_focusedDay), // Displays "2024"
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Row(
                children: [
                  Text(
                    DateFormat.MMMM().format(_focusedDay), // Displays "December"
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isMonthView ? Icons.arrow_drop_up : Icons.arrow_drop_down,
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
                DateFormat.d().format(DateTime.now()), // Current day
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
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          DaysOfWeek(highlightCurrentDay: true), // Use the updated DaysOfWeek widget
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
            },
          )
              : WeekView(
            focusedDay: _focusedDay,
            selectedDay: _selectedDay,
            events: _events, // Pass the events list here
            onDaySelected: (day) {
              setState(() {
                _selectedDay = day;
              });
            },
          ),
          const PlaceholderMessage(),
        ],
      ),
    );
  }
}

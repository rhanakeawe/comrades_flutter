import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  String? _selectedType = '';

  String? _eventName = '';
  String? _eventDate = '';
  String? _eventType = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'Home',
          style: GoogleFonts.teko(color: Colors.white, fontSize: 48),
        ),
      ),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      '$_eventDate',
                      style: GoogleFonts.teko(fontSize: 30),
                    )),
                SizedBox(
                  width: 200,
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Event Name'),
                    onChanged: (text) {
                      setState(() {
                        _eventName = text;
                      });
                    },
                  ),
                ),
                TableCalendar(
                  focusedDay: _focusedDay,
                  firstDay: DateTime.utc(2000, 1, 1),
                  lastDay: DateTime.utc(2100, 1, 1),
                  calendarFormat: CalendarFormat.month,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDay, selectedDay)) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                        _eventDate =
                            '${_selectedDay.month} / ${_selectedDay.day} / ${_selectedDay.year}';
                      });
                    }
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    value: _selectedType != '' ? _selectedType : '',
                    items: const [
                      DropdownMenuItem(
                        value: '',
                        child: Text(''),
                      ),
                      DropdownMenuItem(
                        value: 'Birthday',
                        child: Text('Birthday'),
                      ),
                      DropdownMenuItem(
                          value: 'Meeting', child: Text('Meeting')),
                      DropdownMenuItem(value: 'Party', child: Text('Party'))
                    ],
                    onChanged: (String? value) {
                      setState(() {
                        _selectedType = value!;
                        _eventType = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextButton(
                    style: ButtonStyle(
                        foregroundColor:
                            WidgetStateProperty.all<Color>(Colors.white),
                        backgroundColor: _eventType != '' &&
                                _eventDate != '' &&
                                _eventName != ''
                            ? WidgetStateProperty.all<Color>(Colors.red)
                            : WidgetStateProperty.all<Color>(Colors.grey)),
                    onPressed:
                        _eventType != '' && _eventDate != '' && _eventName != ''
                            ? () {}
                            : null,
                    child: const Text('Set'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

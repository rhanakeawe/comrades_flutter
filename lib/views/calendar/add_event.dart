import 'package:flutter/material.dart';

class AddEventWidget extends StatefulWidget {
  final Function(String title, DateTime startTime, DateTime endTime) onAddEvent;
  final Function(DateTime startTime, DateTime endTime) onAddUnavailability;

  const AddEventWidget({
    super.key,
    required this.onAddEvent,
    required this.onAddUnavailability,
  });

  @override
  State<AddEventWidget> createState() => _AddEventWidgetState();
}

class _AddEventWidgetState extends State<AddEventWidget> {
  final TextEditingController _titleController = TextEditingController();
  DateTime? _startTime;
  DateTime? _endTime;

  void _selectDateTime(BuildContext context, bool isStartTime) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      final selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (selectedTime != null) {
        final dateTime = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          selectedTime.hour,
          selectedTime.minute,
        );

        setState(() {
          if (isStartTime) {
            _startTime = dateTime;
          } else {
            _endTime = dateTime;
          }
        });
      }
    }
  }

  void _validateAndAddEvent() {
    if (_titleController.text.isNotEmpty &&
        _startTime != null &&
        _endTime != null) {
      if (_startTime!.isBefore(_endTime!)) {
        // Add the event
        widget.onAddEvent(
          _titleController.text,
          _startTime!,
          _endTime!,
        );

        // Add unavailability
        widget.onAddUnavailability(
          _startTime!,
          _endTime!,
        );

        Navigator.pop(context);
      } else {
        // Show error if start time is after end time
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Start time must be before end time'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      // Show error if any field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All fields are required'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add Event',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Event Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => _selectDateTime(context, true),
                    child: Text(
                      _startTime != null
                          ? 'Start: ${_startTime!.toLocal()}'.split(' ')[0]
                          : 'Select Start Time',
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextButton(
                    onPressed: () => _selectDateTime(context, false),
                    child: Text(
                      _endTime != null
                          ? 'End: ${_endTime!.toLocal()}'.split(' ')[0]
                          : 'Select End Time',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _validateAndAddEvent,
                  child: const Text('Add'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

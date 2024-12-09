import 'package:flutter/material.dart';

class AddEventDialog extends StatelessWidget {
  final Function(String title, DateTime startTime, DateTime endTime, bool isPersonal) onAddEvent;

  const AddEventDialog({super.key, required this.onAddEvent});

  @override
  Widget build(BuildContext context) {
    String title = '';
    DateTime? startTime;
    DateTime? endTime;

    return AlertDialog(
      title: const Text('Add Event'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(labelText: 'Title'),
            onChanged: (value) => title = value,
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'Start Time (yyyy-MM-dd HH:mm)'),
            onChanged: (value) {
              try {
                startTime = DateTime.parse(value);
              } catch (e) {
                startTime = null;
              }
            },
          ),
          TextField(
            decoration: const InputDecoration(labelText: 'End Time (yyyy-MM-dd HH:mm)'),
            onChanged: (value) {
              try {
                endTime = DateTime.parse(value);
              } catch (e) {
                endTime = null;
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (title.isNotEmpty && startTime != null && endTime != null) {
              onAddEvent(title, startTime!, endTime!, true);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

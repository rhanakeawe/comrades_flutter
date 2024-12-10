import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Comrades/views/account/non-negotiables/days_of_week_enum.dart';

class AddNonNegotiableDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onAdd;

  const AddNonNegotiableDialog({Key? key, required this.onAdd})
      : super(key: key);

  @override
  _AddNonNegotiableDialogState createState() => _AddNonNegotiableDialogState();
}

class _AddNonNegotiableDialogState extends State<AddNonNegotiableDialog> {
  String? typeValue;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  Set<DaysOfWeek> selectedDays = <DaysOfWeek>{};

  Future<void> _pickTime(BuildContext context, TimeOfDay? initialTime,
      void Function(TimeOfDay) onTimePicked) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(data: ThemeData.dark(), child: child!);
      },
    );
    if (pickedTime != null) {
      onTimePicked(pickedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      title: Text(
        "Add Non-Negotiable",
        style: GoogleFonts.poppins(fontSize: 20, color: Colors.white),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton(
            hint: Text("Type", style: const TextStyle(color: Colors.white)),
            style: const TextStyle(color: Colors.white),
            dropdownColor: Colors.grey[900],
            value: typeValue,
            items: const [
              DropdownMenuItem(value: "Sleeping", child: Text("Sleeping")),
              DropdownMenuItem(value: "Working", child: Text("Working")),
              DropdownMenuItem(value: "Personal", child: Text("Personal")),
              DropdownMenuItem(value: "Other", child: Text("Other")),
            ],
            onChanged: (String? value) {
              setState(() {
                typeValue = value!;
              });
            },
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _pickTime(
                      context, startTime, (time) => setState(() => startTime = time)),
                  child: Text(
                    startTime != null
                        ? "Start: ${startTime!.format(context)}"
                        : "Set Start Time",
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _pickTime(
                      context, endTime, (time) => setState(() => endTime = time)),
                  child: Text(
                    endTime != null
                        ? "End: ${endTime!.format(context)}"
                        : "Set End Time",
                  ),
                ),
              ),
            ],
          ),
          Wrap(
            spacing: 5.0,
            children: DaysOfWeek.values.map((day) {
              return FilterChip(
                label: Text(day.name),
                selected: selectedDays.contains(day),
                onSelected: (bool selected) {
                  setState(() {
                    if (selected) {
                      selectedDays.add(day);
                    } else {
                      selectedDays.remove(day);
                    }
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel", style: TextStyle(color: Colors.red)),
        ),
        ElevatedButton(
          onPressed: () {
            if (typeValue != null &&
                startTime != null &&
                endTime != null &&
                selectedDays.isNotEmpty) {
              widget.onAdd({
                'type': typeValue!,
                'startTime': "${startTime!.hour}:${startTime!.minute}:00",
                'endTime': "${endTime!.hour}:${endTime!.minute}:00",
                'days': selectedDays.map((day) => day.name).toList(),
              });
              Navigator.pop(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("All fields are required!")),
              );
            }
          },
          child: const Text("Add"),
        ),
      ],
    );
  }
}

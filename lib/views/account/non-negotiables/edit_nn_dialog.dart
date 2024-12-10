import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Comrades/views/account/non-negotiables/days_of_week_enum.dart';

class EditNonNegotiableDialog extends StatefulWidget {
  final Map<String, dynamic> nonNegotiable;
  final Function(Map<String, dynamic>) onSave;

  const EditNonNegotiableDialog({
    Key? key,
    required this.nonNegotiable,
    required this.onSave,
  }) : super(key: key);

  @override
  _EditNonNegotiableDialogState createState() =>
      _EditNonNegotiableDialogState();
}

class _EditNonNegotiableDialogState extends State<EditNonNegotiableDialog> {
  late String typeValue;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  late Set<DaysOfWeek> selectedDays;

  @override
  void initState() {
    super.initState();
    typeValue = widget.nonNegotiable['type'];
    startTime = TimeOfDay(
      hour: int.parse(widget.nonNegotiable['startTime'].split(':')[0]),
      minute: int.parse(widget.nonNegotiable['startTime'].split(':')[1]),
    );
    endTime = TimeOfDay(
      hour: int.parse(widget.nonNegotiable['endTime'].split(':')[0]),
      minute: int.parse(widget.nonNegotiable['endTime'].split(':')[1]),
    );
    selectedDays = widget.nonNegotiable['days']
        .map<DaysOfWeek>(
          (day) => DaysOfWeek.values.firstWhere((e) => e.name == day),
    )
        .toSet();
  }

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
        "Edit Non-Negotiable",
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
            if (typeValue.isNotEmpty &&
                startTime != null &&
                endTime != null &&
                selectedDays.isNotEmpty) {
              widget.onSave({
                'type': typeValue,
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
          child: const Text("Save"),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class NonNegotiablesPage extends StatefulWidget {
  @override
  _NonNegotiablesPageState createState() => _NonNegotiablesPageState();
}

class _NonNegotiablesPageState extends State<NonNegotiablesPage> {
  List<Map<String, dynamic>> nonNegotiables = [];

  void _addOrEditNonNegotiable([int? index]) {
    final isEditing = index != null;
    final TextEditingController categoryController = TextEditingController(
      text: isEditing ? nonNegotiables[index]['category'] : '',
    );
    TimeOfDay? startTime = isEditing ? nonNegotiables[index]['startTime'] : null;
    TimeOfDay? endTime = isEditing ? nonNegotiables[index]['endTime'] : null;
    List<bool> selectedDays = isEditing
        ? List.from(nonNegotiables[index]['days'])
        : List.filled(7, false);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.grey[900],
              title: Text(
                isEditing ? 'Edit Non-Negotiable' : 'Add Non-Negotiable',
                style: TextStyle(color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.grey[800],
                    value: categoryController.text.isNotEmpty
                        ? categoryController.text
                        : null,
                    items: ['Sleep', 'Work', 'Personal', 'Other']
                        .map((category) =>
                        DropdownMenuItem(value: category, child: Text(category, style: TextStyle(color: Colors.white))))
                        .toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        categoryController.text = value!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Category',
                      labelStyle: TextStyle(color: Colors.white),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final pickedTime = await showTimePicker(
                              context: context,
                              initialTime: startTime ?? TimeOfDay.now(),
                              builder: (context, child) {
                                return Theme(
                                  data: ThemeData.dark(),
                                  child: child!,
                                );
                              },
                            );
                            if (pickedTime != null) {
                              setDialogState(() {
                                startTime = pickedTime;
                              });
                            }
                          },
                          child: Text(startTime != null
                              ? 'Start: ${startTime!.format(context)}'
                              : 'Set Start Time'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final pickedTime = await showTimePicker(
                              context: context,
                              initialTime: endTime ?? TimeOfDay.now(),
                              builder: (context, child) {
                                return Theme(
                                  data: ThemeData.dark(),
                                  child: child!,
                                );
                              },
                            );
                            if (pickedTime != null) {
                              setDialogState(() {
                                endTime = pickedTime;
                              });
                            }
                          },
                          child: Text(endTime != null
                              ? 'End: ${endTime!.format(context)}'
                              : 'Set End Time'),
                        ),
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 8,
                    children: List.generate(7, (i) {
                      final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                      return FilterChip(
                        label: Text(days[i], style: TextStyle(color: Colors.white)),
                        selected: selectedDays[i],
                        onSelected: (selected) {
                          setDialogState(() {
                            selectedDays[i] = selected;
                          });
                        },
                        backgroundColor: Colors.grey[700],
                        selectedColor: Colors.red,
                      );
                    }),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel', style: TextStyle(color: Colors.red)),
                ),
                ElevatedButton(
                  onPressed: () {
                    final nonNegotiable = {
                      'category': categoryController.text,
                      'startTime': startTime,
                      'endTime': endTime,
                      'days': selectedDays,
                    };
                    setState(() {
                      if (isEditing) {
                        nonNegotiables[index] = nonNegotiable;
                      } else {
                        nonNegotiables.add(nonNegotiable);
                      }
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteNonNegotiable(int index) {
    setState(() {
      nonNegotiables.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // Set the background color of the AppBar
        title: Text(
          'Non-Negotiables',
          style: TextStyle(color: Colors.white), // Set the title text color
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.white), // Set the icon color
            onPressed: () => _addOrEditNonNegotiable(),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: nonNegotiables.isEmpty
          ? Center(
        child: Text(
          'No non-negotiables yet. Tap + to add one.',
          style: TextStyle(color: Colors.grey),
        ),
      )
          : ListView.separated(
        itemCount: nonNegotiables.length,
        separatorBuilder: (context, index) => Divider(
          color: Colors.grey[700],
          thickness: 1,
          height: 1,
        ),
        itemBuilder: (context, index) {
          final item = nonNegotiables[index];
          return Container(
            color: Colors.black,
            child: ListTile(
              title: Text(item['category'], style: TextStyle(color: Colors.white)),
              subtitle: Text(
                '${item['startTime']?.format(context)} - ${item['endTime']?.format(context)}\nDays: ${item['days'].asMap().entries.where((e) => e.value).map((e) => ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][e.key]).join(', ')}',
                style: TextStyle(color: Colors.grey),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.white),
                    onPressed: () => _addOrEditNonNegotiable(index),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteNonNegotiable(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

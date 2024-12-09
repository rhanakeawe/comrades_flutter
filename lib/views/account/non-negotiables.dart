import 'package:Comrades/querylist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:google_fonts/google_fonts.dart';

class NonNegotiablesPage extends StatefulWidget {
  const NonNegotiablesPage({super.key});

  @override
  _NonNegotiablesPageState createState() => _NonNegotiablesPageState();
}

enum DaysOfWeek {
  Monday,
  Tuesday,
  Wednesday,
  Thursday,
  Friday,
  Saturday,
  Sunday
}

class _NonNegotiablesPageState extends State<NonNegotiablesPage> {
  List<Map<String, dynamic>> nonNegotiablesList = [];
  List<String> documentIds = [];

  final QueryList _queryList = QueryList();
  var currentUser = FirebaseAuth.instance.currentUser?.email;

  Icon iconType(String type) {
    if (type == "Sleeping") {
      return Icon(Icons.brightness_2, color: Colors.white);
    } else if (type == 'Working') {
      return Icon(Icons.work, color: Colors.white);
    } else if (type == 'Personal') {
      return Icon(Icons.person, color: Colors.white);
    } else if (type == 'Other') {
      return Icon(Icons.question_mark_rounded, color: Colors.white);
    } else {
      return Icon(Icons.error, color: Colors.white);
    }
  }
  String _formatTime(String time) {
    // Parse the time string into hours and minutes
    List<String> parts = time.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    String period = hour >= 12 ? "PM" : "AM";

    // Convert hour to 12-hour format
    hour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    // Format time as "hh:mm AM/PM"
    return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period";
  }


  Future<void> getNonNegotiables() async {
    if (nonNegotiablesList.isEmpty) {
      QuerySnapshot<Map<String, dynamic>> nonNegotiableSnapshot =
      await _queryList.fetchList(
          "non-negotiables", "userEmail", currentUser!);
      for (var nonNegotiable in nonNegotiableSnapshot.docs) {
        setState(() {
          nonNegotiablesList.add({
            'type': nonNegotiable.data()["type"],
            'days': nonNegotiable.data()["days"],
            'startTime': nonNegotiable.data()["startTime"],
            'endTime': nonNegotiable.data()["endTime"],
          });
          documentIds.add(nonNegotiable.id);
        });
      }
    }
  }

  Future<void> refreshNonNegotiables() async {
    nonNegotiablesList.clear();
    documentIds.clear();
    await getNonNegotiables();
  }

  void _addNonNegotiable() {
    String? typeValue;
    TimeOfDay? startTime;
    TimeOfDay? endTime;
    Set<DaysOfWeek> days = <DaysOfWeek>{};

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
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
                  hint: Text("Type", style: TextStyle(color: Colors.white)),
                  style: TextStyle(color: Colors.white),
                  dropdownColor: Colors.grey[900],
                  value: typeValue,
                  items: [
                    DropdownMenuItem(
                        value: "Sleeping", child: Text("Sleeping")),
                    DropdownMenuItem(value: "Working", child: Text("Working")),
                    DropdownMenuItem(
                        value: "Personal", child: Text("Personal")),
                    DropdownMenuItem(value: "Other", child: Text("Other")),
                  ],
                  onChanged: (String? value) {
                    setDialogState(() {
                      typeValue = value!;
                    });
                  },
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
                                  data: ThemeData.dark(), child: child!);
                            },
                          );
                          if (pickedTime != null) {
                            setDialogState(() {
                              startTime = pickedTime;
                            });
                          }
                        },
                        child: Text(startTime != null
                            ? "Start: ${startTime!.format(context)}"
                            : "Set Start Time"),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final pickedTime = await showTimePicker(
                            context: context,
                            initialTime: endTime ?? TimeOfDay.now(),
                            builder: (context, child) {
                              return Theme(
                                  data: ThemeData.dark(), child: child!);
                            },
                          );
                          if (pickedTime != null) {
                            setDialogState(() {
                              endTime = pickedTime;
                            });
                          }
                        },
                        child: Text(endTime != null
                            ? "End: ${endTime!.format(context)}"
                            : "Set End Time"),
                      ),
                    ),
                  ],
                ),
                Wrap(
                  spacing: 5.0,
                  children: DaysOfWeek.values.map((DaysOfWeek day) {
                    return FilterChip(
                      label: Text(day.name),
                      selected: days.contains(day),
                      onSelected: (bool selected) {
                        setDialogState(() {
                          if (selected) {
                            days.add(day);
                          } else {
                            days.remove(day);
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
                child: Text("Cancel", style: TextStyle(color: Colors.red)),
              ),
              ElevatedButton(
                onPressed: () {
                  if (typeValue != null &&
                      startTime != null &&
                      endTime != null &&
                      days.isNotEmpty) {
                    var daysConverted = days.map((day) => day.name).toList();
                    FirebaseFirestore.instance
                        .collection("non-negotiables")
                        .add({
                      'type': typeValue,
                      'startTime': "${startTime!.hour}:${startTime!.minute}:00",
                      'endTime': "${endTime!.hour}:${endTime!.minute}:00",
                      'days': daysConverted,
                      'userEmail': currentUser!,
                    });
                    refreshNonNegotiables();
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("All fields are required!")),
                    );
                  }
                },
                child: Text("Add"),
              ),
            ],
          );
        });
      },
    );
  }

  void _editNonNegotiable(int index) {
    final nonNegotiable = nonNegotiablesList[index];

    // Extract existing values
    String? typeValue = nonNegotiable['type'];
    TimeOfDay? startTime = TimeOfDay(
        hour: int.parse(nonNegotiable['startTime'].split(':')[0]),
        minute: int.parse(nonNegotiable['startTime'].split(':')[1]));
    TimeOfDay? endTime = TimeOfDay(
        hour: int.parse(nonNegotiable['endTime'].split(':')[0]),
        minute: int.parse(nonNegotiable['endTime'].split(':')[1]));
    Set<DaysOfWeek> days = nonNegotiable['days']
        .map<DaysOfWeek>(
            (day) => DaysOfWeek.values.firstWhere((e) => e.name == day))
        .toSet();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setDialogState) {
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
                  hint: Text("Type", style: TextStyle(color: Colors.white)),
                  style: TextStyle(color: Colors.white),
                  dropdownColor: Colors.grey[900],
                  value: typeValue,
                  items: [
                    DropdownMenuItem(
                        value: "Sleeping", child: Text("Sleeping")),
                    DropdownMenuItem(value: "Working", child: Text("Working")),
                    DropdownMenuItem(
                        value: "Personal", child: Text("Personal")),
                    DropdownMenuItem(value: "Other", child: Text("Other")),
                  ],
                  onChanged: (String? value) {
                    setDialogState(() {
                      typeValue = value!;
                    });
                  },
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
                                  data: ThemeData.dark(), child: child!);
                            },
                          );
                          if (pickedTime != null) {
                            setDialogState(() {
                              startTime = pickedTime;
                            });
                          }
                        },
                        child: Text(startTime != null
                            ? "Start: ${startTime!.format(context)}"
                            : "Set Start Time"),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final pickedTime = await showTimePicker(
                            context: context,
                            initialTime: endTime ?? TimeOfDay.now(),
                            builder: (context, child) {
                              return Theme(
                                  data: ThemeData.dark(), child: child!);
                            },
                          );
                          if (pickedTime != null) {
                            setDialogState(() {
                              endTime = pickedTime;
                            });
                          }
                        },
                        child: Text(endTime != null
                            ? "End: ${endTime!.format(context)}"
                            : "Set End Time"),
                      ),
                    ),
                  ],
                ),
                Wrap(
                  spacing: 5.0,
                  children: DaysOfWeek.values.map((DaysOfWeek day) {
                    return FilterChip(
                      label: Text(day.name),
                      selected: days.contains(day),
                      onSelected: (bool selected) {
                        setDialogState(() {
                          if (selected) {
                            days.add(day);
                          } else {
                            days.remove(day);
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
                child: Text("Cancel", style: TextStyle(color: Colors.red)),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (typeValue != null &&
                      startTime != null &&
                      endTime != null &&
                      days.isNotEmpty) {
                    var daysConverted = days.map((day) => day.name).toList();
                    // Update Firebase
                    await FirebaseFirestore.instance
                        .collection("non-negotiables")
                        .doc(documentIds[index])
                        .update({
                      'type': typeValue,
                      'startTime': "${startTime!.hour}:${startTime!.minute}:00",
                      'endTime': "${endTime!.hour}:${endTime!.minute}:00",
                      'days': daysConverted,
                    });

                    // Refresh the UI
                    refreshNonNegotiables();
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("All fields are required!")),
                    );
                  }
                },
                child: Text("Save"),
              ),
            ],
          );
        });
      },
    );
  }

  void _deleteNonNegotiable(int index) async {
    await FirebaseFirestore.instance
        .collection("non-negotiables")
        .doc(documentIds[index])
        .delete();
    setState(() {
      nonNegotiablesList.removeAt(index);
      documentIds.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    getNonNegotiables();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Non-Negotiables",
            style: GoogleFonts.roboto(fontSize: 24, color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: _addNonNegotiable,
            icon: Icon(Icons.add, color: Colors.white),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refreshNonNegotiables,
        child: ListView.builder(
          itemCount: nonNegotiablesList.length,
          itemBuilder: (context, index) {
            final nonNegotiable = nonNegotiablesList[index];
            return Dismissible(
              key: Key(documentIds[index]),
              background: Container(
                color: Colors.blue,
                alignment: Alignment.centerLeft,
                child: Icon(Icons.edit, color: Colors.white),
              ),
              secondaryBackground: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                child: Icon(Icons.delete, color: Colors.white),
              ),
              confirmDismiss: (direction) async {
                if (direction == DismissDirection.startToEnd) {
                  _editNonNegotiable(index);
                  return false;
                } else if (direction == DismissDirection.endToStart) {
                  return await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Confirm Delete"),
                      content: Text("Are you sure you want to delete this?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text("Delete"),
                        ),
                      ],
                    ),
                  );
                }
                return false;
              },
              onDismissed: (direction) {
                if (direction == DismissDirection.endToStart) {
                  _deleteNonNegotiable(index);
                }
              },
              child: GFListTile(
                shadow: BoxShadow(color: Colors.white, blurRadius: 1),
                padding: const EdgeInsets.all(5.0),
                color: Colors.black45,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      nonNegotiable['type'],
                      style: GoogleFonts.roboto(fontSize: 20, color: Colors.white),
                    ),
                    Expanded(child: Container()),
                    iconType(nonNegotiable['type']),
                  ],
                ),
                description: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Days: ${nonNegotiable['days'].join(', ')}",
                        style: GoogleFonts.poppins(
                          letterSpacing: 1,
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Time: ${_formatTime(nonNegotiable['startTime'])} - ${_formatTime(nonNegotiable['endTime'])}",
                        style: GoogleFonts.poppins(
                          letterSpacing: 1,
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:Comrades/querylist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:google_fonts/google_fonts.dart';

class NonNegotiablesPage extends StatefulWidget {
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

  final QueryList _queryList = QueryList();
  var currentUser = FirebaseAuth.instance.currentUser?.email;

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
        });
      }
    }
  }

  Future<void> refreshNonNegotiables() async {
    print("refresh non negotiables");
    nonNegotiablesList.clear();
    getNonNegotiables();
  }

  String? typeValue;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  Set<DaysOfWeek> days = <DaysOfWeek>{};

  addNonNegotiable(String? typeValue, TimeOfDay? startTime, TimeOfDay? endTime,
      Set<DaysOfWeek> days) {
    print(days.toList().toString());
    var daysConverted = [];
    for (var day in days) {
      daysConverted.add(day.name);
    }
    print(daysConverted);
    FirebaseFirestore db = FirebaseFirestore.instance;
    final inputNonNegotiable = <String, dynamic>{
      'type': typeValue,
      'startTime': "${startTime?.hour}:${startTime?.minute}:00",
      'endTime': "${endTime?.hour}:${endTime?.minute}:00",
      'days': daysConverted,
      'userEmail': currentUser!,
    };
    try {
      db.collection("non-negotiables").add(inputNonNegotiable).then(
          (documentSnapshot) =>
              print("Added Data with ID: ${documentSnapshot.id}"));
    } catch (e) {
      print(e);
    }
    Navigator.pop(context);
  }

  void _addNonNegotiable() {
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
                    hint: Text(
                      "Type",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: TextStyle(color: Colors.white),
                    dropdownColor: Colors.grey[900],
                    value: typeValue,
                    items: [
                      DropdownMenuItem(
                        value: "Sleeping",
                        child: Text("Sleeping"),
                      ),
                      DropdownMenuItem(
                        value: "Working",
                        child: Text("Working"),
                      ),
                      DropdownMenuItem(
                        value: "Personal",
                        child: Text("Personal"),
                      ),
                      DropdownMenuItem(
                        value: "Other",
                        child: Text("Other"),
                      ),
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
                                        data: ThemeData.dark(),
                                        child: child!,
                                      );
                                    });
                                if (pickedTime != null) {
                                  setDialogState(() {
                                    startTime = pickedTime;
                                  });
                                }
                              },
                              child: Text(startTime != null
                                  ? "Start: ${startTime!.format(context)}"
                                  : "Set Start Time"))),
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
                                    });
                                if (pickedTime != null) {
                                  setDialogState(() {
                                    endTime = pickedTime;
                                  });
                                }
                              },
                              child: Text(endTime != null
                                  ? "End: ${endTime!.format(context)}"
                                  : "Set End Time"))),
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
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            if (typeValue != null &&
                                startTime != null &&
                                endTime != null &&
                                days.isNotEmpty) {
                              addNonNegotiable(
                                  typeValue, startTime, endTime, days);
                            } else {
                              if (typeValue == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Missing type")));
                              } else if (startTime == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text("Missing start time")));
                              } else if (endTime == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text("Missing end time")));
                              } else if (days.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text("Missing days of the week")));
                              }
                            }
                          },
                          child: Text("Add")),
                      ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Cancel")),
                    ],
                  )
                ],
              ),
            );
          });
        });
  }

  Icon iconType(String type) {
    if (type == "Sleeping") {
      return Icon(Icons.brightness_2, color: Colors.white);
    } else if (type == 'Working') {
      return Icon(Icons.work, color: Colors.white);
    } else if (type == 'Personal') {
      return Icon(Icons.person_remove, color: Colors.white);
    } else if (type == 'Other') {
      return Icon(Icons.question_mark_rounded, color: Colors.white);
    } else {
      return Icon(Icons.error, color: Colors.white);
    }
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
        title: Text(
          "Non-Negotiables",
          style: GoogleFonts.roboto(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              onPressed: _addNonNegotiable,
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ))
        ],
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RefreshIndicator(
            onRefresh: refreshNonNegotiables,
            child: Center(
                child: nonNegotiablesList.isNotEmpty
                    ? ListView.builder(
                        itemCount: nonNegotiablesList.length,
                        itemBuilder: (context, index) {
                          final nonNegotiable = nonNegotiablesList[index];
                          return GFListTile(
                            shadow: BoxShadow(color: Colors.white, blurRadius: 1),
                            padding: const EdgeInsets.all(5.0),
                            color: Colors.black45,
                            title: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    nonNegotiable['type'],
                                    style: GoogleFonts.roboto(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Expanded(child: Container()),
                                  iconType(nonNegotiable['type'])
                                ]),
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
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    "Time: ${nonNegotiable['startTime'].toString()} - ${nonNegotiable['endTime'].toString()}",
                                    style: GoogleFonts.poppins(
                                        letterSpacing: 1,
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : Text("No Non-Negotiables yet. Tap + to add one.",
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          color: Colors.grey,
                        ))),
          )),
    );
  }
}

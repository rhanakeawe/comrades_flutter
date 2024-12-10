import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Comrades/views/account/non-negotiables/nn_service.dart';
import 'package:Comrades/views/account/non-negotiables/nn_list_tile.dart';
import 'package:Comrades/views/account/non-negotiables/add_nn_dialog.dart';
import 'package:Comrades/views/account/non-negotiables/edit_nn_dialog.dart';
import 'package:Comrades/views/account/non-negotiables/days_of_week_enum.dart';

class NonNegotiablesPage extends StatefulWidget {
  const NonNegotiablesPage({super.key});

  @override
  _NonNegotiablesPageState createState() => _NonNegotiablesPageState();
}

class _NonNegotiablesPageState extends State<NonNegotiablesPage> {
  List<Map<String, dynamic>> nonNegotiablesList = [];
  List<String> documentIds = [];
  final NonNegotiablesService _service = NonNegotiablesService();

  @override
  void initState() {
    super.initState();
    _fetchNonNegotiables();
  }

  Future<void> _fetchNonNegotiables() async {
    final data = await _service.fetchNonNegotiables();
    setState(() {
      nonNegotiablesList = data.nonNegotiablesList;
      documentIds = data.documentIds;
    });
  }

  Future<void> _refreshNonNegotiables() async {
    nonNegotiablesList.clear();
    documentIds.clear();
    await _fetchNonNegotiables();
  }

  void _addNonNegotiable() async {
    await showDialog(
      context: context,
      builder: (context) => AddNonNegotiableDialog(
        onAdd: (nonNegotiable) async {
          await _service.addNonNegotiable(nonNegotiable);
          await _refreshNonNegotiables();
        },
      ),
    );
  }

  void _editNonNegotiable(int index) async {
    await showDialog(
      context: context,
      builder: (context) => EditNonNegotiableDialog(
        nonNegotiable: nonNegotiablesList[index],
        onSave: (updatedData) async {
          await _service.updateNonNegotiable(documentIds[index], updatedData);
          await _refreshNonNegotiables();
        },
      ),
    );
  }

  void _deleteNonNegotiable(int index) async {
    await _service.deleteNonNegotiable(documentIds[index]);
    setState(() {
      nonNegotiablesList.removeAt(index);
      documentIds.removeAt(index);
    });
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
        onRefresh: _refreshNonNegotiables,
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
              child: NonNegotiableListTile(
                nonNegotiable: nonNegotiable,
                onEdit: () => _editNonNegotiable(index),
                onDelete: () => _deleteNonNegotiable(index),
              ),
            );
          },
        ),
      ),
    );
  }
}

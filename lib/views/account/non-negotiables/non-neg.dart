import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:Comrades/views/account/non-negotiables/nn_service.dart';
import 'package:Comrades/views/account/non-negotiables/nn_list_tile.dart';
import 'package:Comrades/views/account/non-negotiables/add_nn_dialog.dart';
import 'package:Comrades/views/account/non-negotiables/edit_nn_dialog.dart';


class NonNegotiablesPage extends StatefulWidget {
  const NonNegotiablesPage({super.key});

  @override
  _NonNegotiablesPageState createState() => _NonNegotiablesPageState();
}

class _NonNegotiablesPageState extends State<NonNegotiablesPage> {
  late Future<NonNegotiablesData> _nonNegotiablesData;
  final NonNegotiablesService _service = NonNegotiablesService();

  @override
  void initState() {
    super.initState();
    _nonNegotiablesData = _service.fetchNonNegotiables();
  }

  Future<void> _refreshNonNegotiables() async {
    setState(() {
      _nonNegotiablesData = _service.fetchNonNegotiables();
    });
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

  void _editNonNegotiable(Map<String, dynamic> nonNegotiable, String documentId) async {
    await showDialog(
      context: context,
      builder: (context) => EditNonNegotiableDialog(
        nonNegotiable: nonNegotiable,
        onSave: (updatedData) async {
          await _service.updateNonNegotiable(documentId, updatedData);
          await _refreshNonNegotiables();
        },
      ),
    );
  }

  void _deleteNonNegotiable(String documentId) async {
    await _service.deleteNonNegotiable(documentId);
    await _refreshNonNegotiables();
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
        child: FutureBuilder<NonNegotiablesData>(
          future: _nonNegotiablesData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.nonNegotiablesList.isEmpty) {
              return Center(child: Text('No non-negotiables yet.'));
            } else {
              final nonNegotiablesList = snapshot.data!.nonNegotiablesList;
              final documentIds = snapshot.data!.documentIds;
              return ListView.builder(
                itemCount: nonNegotiablesList.length,
                itemBuilder: (context, index) {
                  final nonNegotiable = nonNegotiablesList[index];
                  final documentId = documentIds[index];
                  return Dismissible(
                    key: Key(documentId),
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
                        _editNonNegotiable(nonNegotiable, documentId);
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
                        _deleteNonNegotiable(documentId);
                      }
                    },
                    child: NonNegotiableListTile(
                      nonNegotiable: nonNegotiable,
                      onEdit: () => _editNonNegotiable(nonNegotiable, documentId),
                      onDelete: () => _deleteNonNegotiable(documentId),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
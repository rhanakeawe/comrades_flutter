import 'package:flutter/material.dart';

class GroupsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Groups'),
      ),
      body: Center(
        child: Text(
          'This is the Groups Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

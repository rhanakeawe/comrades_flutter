import 'package:flutter/material.dart';

class GroupsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Groups'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20), // Adds padding to reduce width usage
            height: 100, // Reducing the height slightly
            width: 410,  // Adjusted width
            decoration: BoxDecoration(
              color: Colors.red,
              border: Border.all(
                color: Colors.white, // Outline color
                width: 3, // Outline thickness
              ),
            ),
            child: Center(
              child: Text(
                'Comrades',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28, // Reduced font size
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 3,
                      color: Colors.black,
                      offset: Offset(1, 1), // Slight shadow to make the text stand out more
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20), // Adds padding to reduce width usage
            height: 100, // Reducing the height slightly
            width: 410,  // Adjusted width
            decoration: BoxDecoration(
              color: Colors.green,
              border: Border.all(
                color: Colors.white, // Outline color
                width: 3, // Outline thickness
              ),
            ),
            child: Center(
              child: Text(
                'Neighborhood',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28, // Reduced font size
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 3,
                      color: Colors.black,
                      offset: Offset(1, 1), // Slight shadow to make the text stand out more
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20), // Adds padding to reduce width usage
            height: 100, // Reducing the height slightly
            width: 410,  // Adjusted width
            decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(
                color: Colors.white, // Outline color
                width: 3, // Outline thickness
              ),
            ),
            child: Center(
              child: Text(
                'Apes',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28, // Reduced font size
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 3,
                      color: Colors.black,
                      offset: Offset(1, 1), // Slight shadow to make the text stand out more
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

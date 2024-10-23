import 'package:flutter/material.dart';

class GroupsPage extends StatelessWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set the entire background to black
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16), // Smaller spacing from the top
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Groups', // Title
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24, // Adjusted font size to match screenshot
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Define what happens when you click + Add Group
                    print('Add Group clicked');
                  },
                  child: Text(
                    '+ Add Group', // Clickable text
                    style: TextStyle(
                      color: Colors.blueAccent, // Brighter blue color for the + Add Group text
                      fontSize: 16, // Adjusted font size
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10), // Adjusted spacing below header
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0), // Reduced horizontal padding for group containers
              child: ListView(
                children: [
                  buildGroupCard('Comrades', Colors.white, Colors.red),
                  SizedBox(height: 12), // Adjusted spacing between group cards
                  buildGroupCard('Apes', Colors.white, Colors.brown),
                  SizedBox(height: 12), // Adjusted spacing between group cards
                  buildGroupCard('Neighborhood', Colors.white, Colors.purple[200]!),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to build each group card with custom text, background color, and a thin, subtle gray border around the bottom section
  Widget buildGroupCard(String groupName, Color textColor, Color topColor) {
    return Container(
      height: 160, // Slightly increased the height of each group card to match the screenshot
      width: double.infinity, // Takes full width within the reduced padding
      decoration: BoxDecoration(
        color: topColor.withOpacity(0.9), // Slight opacity for the top color to match the design
        borderRadius: BorderRadius.circular(10), // Slightly smaller border radius to match the look
      ),
      child: Stack(
        children: [
          // Black bottom section with group name and a subtle, thin gray border around it
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black, // Background color for the group name section
                border: Border.all(
                  color: Colors.grey[500]!, // Subtle gray border color
                  width: 1, // Thinner border width
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                groupName, // Display the passed group name
                style: TextStyle(
                  color: textColor, // Custom color for the group name
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Three dots icon in the top right corner
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              icon: Icon(Icons.more_vert),
              color: Colors.black, // Icon color
              onPressed: () {
                // Add functionality for editing the group
              },
            ),
          ),
        ],
      ),
    );
  }
}

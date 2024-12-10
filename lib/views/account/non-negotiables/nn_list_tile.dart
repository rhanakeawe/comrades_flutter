import 'package:flutter/material.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:google_fonts/google_fonts.dart';

class NonNegotiableListTile extends StatelessWidget {
  final Map<String, dynamic> nonNegotiable;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const NonNegotiableListTile({
    Key? key,
    required this.nonNegotiable,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  Icon _iconType(String type) {
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
    List<String> parts = time.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    String period = hour >= 12 ? "PM" : "AM";
    hour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

    return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period";
  }

  @override
  Widget build(BuildContext context) {
    return GFListTile(
      shadow: const BoxShadow(color: Colors.white, blurRadius: 1),
      padding: const EdgeInsets.all(5.0),
      color: Colors.black45,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            nonNegotiable['type'],
            style: GoogleFonts.roboto(fontSize: 20, color: Colors.white),
          ),
          const Expanded(child: SizedBox()),
          _iconType(nonNegotiable['type']),
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
            const SizedBox(height: 2),
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
    );
  }
}

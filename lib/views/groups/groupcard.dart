import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class GroupCard extends StatelessWidget {
  final String name;
  final String description;
  final String? backgroundImage;
  final VoidCallback onTap;

  const GroupCard({
    super.key,
    required this.name,
    required this.description,
    this.backgroundImage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GFListTile(
      titleText: name,
      subTitleText: description,
      icon: Icon(Icons.people_alt, color: Colors.grey),
      color: Colors.white,
      avatar: GFAvatar(
        backgroundImage: backgroundImage != null ? NetworkImage(backgroundImage!) : null,
      ),
      onTap: onTap,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class GroupCard extends StatelessWidget {
  final String name;
  final String description;
  final IconData icon;
  final String? backgroundImage;
  final VoidCallback onTap;

  const GroupCard({
    super.key,
    required this.name,
    required this.description,
    required this.icon,
    this.backgroundImage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GFListTile(
      titleText: name,
      subTitleText: description,
      icon: Icon(icon, color: Colors.grey),
      color: Colors.white,
      avatar: GFAvatar(
        backgroundImage: backgroundImage != null ? AssetImage(backgroundImage!) : null,
      ),
      onTap: onTap,
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class GroupCard extends StatelessWidget {
  final String name;
  final String description;
  final String backgroundImage;
  final VoidCallback onTap;

  const GroupCard({
    super.key,
    required this.name,
    required this.description,
    required this.backgroundImage,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GFListTile(
      titleText: name,
      subTitleText: description,
      icon: Icon(Icons.people_alt, color: Colors.grey),
      color: Colors.white,
      avatar: CachedNetworkImage(
          imageUrl: backgroundImage,
        imageBuilder: (context, imageProvider) => GFAvatar(
          backgroundImage: imageProvider,
        ),
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
      // avatar: GFAvatar(
      //   backgroundImage: backgroundImage != null ? NetworkImage(backgroundImage!) : null,
      // ),
      onTap: onTap,
    );
  }
}

import 'package:flutter/material.dart';

class PlaceholderMessage extends StatelessWidget {
  const PlaceholderMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          "It looks like all your friends are busy today!",
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}

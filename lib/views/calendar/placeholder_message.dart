import 'package:flutter/material.dart';

class PlaceholderMessage extends StatelessWidget {
  const PlaceholderMessage({super.key, required String message});

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

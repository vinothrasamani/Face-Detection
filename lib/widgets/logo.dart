import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key, required this.radius});
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: const Color.fromARGB(255, 0, 38, 255),
      radius: radius,
      child: Icon(
        Icons.play_circle_fill,
        size: radius * 1.5,
        color: const Color.fromARGB(255, 209, 255, 176),
      ),
    );
  }
}

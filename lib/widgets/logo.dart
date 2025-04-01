import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  const Logo({super.key, required this.radius});
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: NetworkImage(
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSYPRAbTxfmdV_jIUYxjbtjz1iv8gqDsv4Jsg&s'),
      radius: radius,
    );
  }
}

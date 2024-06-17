import 'package:flutter/material.dart';

const TextStyle labelTextStyle =
    TextStyle(fontWeight: FontWeight.bold, fontSize: 18);

const double iconSize = 80;

const double gap = 15;

class IconContent extends StatelessWidget {
  final IconData icon;
  final String text;

  const IconContent({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: iconSize,
        ),
        const SizedBox(height: gap),
        Text(
          text,
          style: labelTextStyle,
        )
      ],
    );
  }
}

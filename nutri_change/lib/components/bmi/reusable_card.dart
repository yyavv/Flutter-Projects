import 'package:flutter/material.dart';

const Color cardColor = Color(0xFF1D1E33);

class ReusableCard extends StatelessWidget {
  final Color color;
  final Widget cardChild;

  final VoidCallback? onPress;

  const ReusableCard(
      {super.key,
      this.color = cardColor,
      required this.cardChild,
      this.onPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.circular(10), color: color),
        child: cardChild,
      ),
    );
  }
}

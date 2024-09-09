import 'package:flutter/material.dart';

Color k_greenButtonColor = const Color(0xff7ed957);
Color k_redButtonColor = const Color(0xffff6505);

SizedBox buttonExchange(
    {required String name,
    required Color color,
    required VoidCallback function}) {
  return SizedBox(
    width: 150,
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(
            horizontal: 16.0, vertical: 12.0), // Padding inside the button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0), // Rounded corners
        ),
        elevation: 5, // Shadow effect
      ),
      onPressed: function,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white, // Text color
              fontSize: 16, // Font size
              fontWeight: FontWeight.bold, // Bold font
            ),
          ),
        ],
      ),
    ),
  );
}

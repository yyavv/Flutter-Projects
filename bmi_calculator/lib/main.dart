import 'package:flutter/material.dart';
import 'screens/input_page.dart';

void main() => runApp(const BMICalculator());

const Color backgroundColor = Color(0xFF0A0E21);

class BMICalculator extends StatelessWidget {
  const BMICalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        appBarTheme: const AppBarTheme(
            backgroundColor: backgroundColor, centerTitle: true, elevation: 2),
      ),
      home: const InputPage(),
    );
  }
}

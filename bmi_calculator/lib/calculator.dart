import 'dart:math';
import 'dart:ui';

class Calculator {
  Calculator({this.height = 170, this.weight = 60, this.age = 25});

  final int height;
  final int weight;
  final int age;

  late double _bmi;

  String calculateBMI() {
    _bmi = weight / pow(height / 100, 2);

    return _bmi.toStringAsFixed(1);
  }

  String getResult() {
    if (_bmi < 18.5) {
      return 'Underweight';
    } else if (_bmi < 24.9) {
      return 'Normal';
    } else if (_bmi < 29.9) {
      return 'Overweight';
    } else {
      return 'Obese';
    }
  }

  Color getColor() {
    if (_bmi < 18.5) {
      return const Color(0xFFFFA500);
    } else if (_bmi < 24.9) {
      return const Color(0xFF24D876);
    } else if (_bmi < 29.9) {
      return const Color(0xFFFFA500);
    } else {
      return const Color(0xFFB70404);
    }
  }

  String getInterpretation() {
    if (_bmi < 18.5) {
      return 'You have a lower than normal body weight. You can eat a bit more!';
    } else if (_bmi < 24.9) {
      return 'You have a normal body weight. Good job!';
    } else if (_bmi < 29.9) {
      return 'You have a higher than a normal body weight. Try to exercise more.';
    } else {
      return 'Obese';
    }
  }
}

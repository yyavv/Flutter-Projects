import 'package:flutter/material.dart';
import 'package:nutri_change/screens/home_page.dart';
import 'package:nutri_change/theme/theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nutri Change',
      home: const HomePage(),
    );
  }
}

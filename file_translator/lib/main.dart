import 'package:flutter/material.dart';
import 'package:sub_translator/globals.dart';
import 'package:sub_translator/screens/home_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sub_translator/test.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SubVerse',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      scaffoldMessengerKey: snackbarKey,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

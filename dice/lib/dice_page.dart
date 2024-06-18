import 'package:flutter/material.dart';
import 'dart:math';

class DicePage extends StatefulWidget {
  const DicePage({super.key});

  @override
  State<DicePage> createState() => _DicePageState();
}

class _DicePageState extends State<DicePage> {
  int leftDice = 1;
  int rightDice = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff192A51),
      appBar: AppBar(
        title: const Text('Dice',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xffAAA1C8),
      ),
      body: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextButton(
                    onPressed: () {
                      setState(() {
                        changeDice();
                      });
                    },
                    child: Image.asset("images/dice$leftDice.png")),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextButton(
                    onPressed: () {
                      setState(() {
                        changeDice();
                      });
                    },
                    child: Image.asset("images/dice$rightDice.png")),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void changeDice() {
    leftDice = Random().nextInt(6) + 1;
    rightDice = Random().nextInt(6) + 1;
  }
}

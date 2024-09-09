import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nutri_change/screens/bmi.dart';
import 'package:nutri_change/screens/exchange_calculator.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: [const Bmi(), ExchangeCalculator()],
      ),
      // body: Center(
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //     children: [
      //       GestureDetector(
      //         onTap: () {
      //           Navigator.push(context, MaterialPageRoute(builder: (context) {
      //             return Bmi();
      //           }));
      //         },
      //         child: const Icon(
      //           Icons.calculate_outlined,
      //           size: 100,
      //         ),
      //       ),
      //       GestureDetector(
      //         onTap: () {
      //           Navigator.push(context, MaterialPageRoute(builder: (context) {
      //             return ExchangeCalculator();
      //           }));
      //         },
      //         child: const Icon(
      //           Icons.calculate_outlined,
      //           size: 100,
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}

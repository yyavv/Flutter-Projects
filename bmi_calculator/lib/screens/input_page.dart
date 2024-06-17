import 'package:bmi_calculator/calculator.dart';
import 'package:bmi_calculator/screens/results_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../components/icon_content.dart';
import '../components/reusable_content.dart';
import '../components/bottom_button.dart';
import '../components/round_icon_button.dart';

const Color activeColor = Color(0xFF1D1E33);
const Color inactiveColor = Color(0xFF111328);
const TextStyle numberStyle =
    TextStyle(fontWeight: FontWeight.w900, fontSize: 50);
// 4c4e5e
int height = 175;
int weight = 60;
int age = 25;

enum Gender { male, female }

enum Sign { plus, minus }

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  Gender? selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BMI CALCULATOR',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: ReusableCard(
                    onPress: () {
                      setState(() {
                        selectedGender = Gender.male;
                      });
                    },
                    color: selectedGender == Gender.male
                        ? activeColor
                        : inactiveColor,
                    cardChild: const IconContent(
                      icon: Icons.male,
                      text: "MALE",
                    ),
                  ),
                ),
                Expanded(
                    child: ReusableCard(
                        onPress: () {
                          setState(() {
                            selectedGender = Gender.female;
                          });
                        },
                        color: selectedGender == Gender.female
                            ? activeColor
                            : inactiveColor,
                        cardChild: const IconContent(
                          icon: Icons.female,
                          text: "FEMALE",
                        )))
              ],
            ),
          ),
          Expanded(
              child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                if (details.delta.dx > 0 && height < 220) {
                  height += details.delta.dx.toInt();
                } else if (details.delta.dx < 0 && height > 100) {
                  height += details.delta.dx.toInt();
                }

                if (height < 100) {
                  height = 100;
                } else if (height > 220) {
                  height = 220;
                }
              });
            },
            child: ReusableCard(
              cardChild: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "HEIGHT",
                    style: labelTextStyle,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.ideographic,
                    children: [
                      Text(height.toString(), style: numberStyle),
                      const SizedBox(width: 5),
                      const Text(
                        'cm',
                        style: labelTextStyle,
                      ),
                    ],
                  ),
                  // Slider(
                  //   value: height.toDouble(),
                  //   onChanged: (double newHeight) {
                  //     setState(() {
                  //       height = newHeight.toInt();
                  //     });
                  //   },
                  //   min: 100,
                  //   max: 220,
                  //   activeColor: Color(0xFFEB1555),
                  //   inactiveColor: Color(0xFF8D8E98),
                  // )
                ],
              ),
            ),
          )),
          Expanded(
            child: Row(
              children: [
                Expanded(
                    child: ReusableCard(
                  cardChild: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "WEIGHT",
                        style: labelTextStyle,
                      ),
                      Text(
                        weight.toString(),
                        style: numberStyle,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RoundIconButton(
                              icon: FontAwesomeIcons.minus,
                              onPressed: () => setState(() {
                                    weight--;
                                  })),
                          const SizedBox(width: 10),
                          RoundIconButton(
                              icon: FontAwesomeIcons.plus,
                              onPressed: () => setState(() {
                                    weight++;
                                  }))
                        ],
                      )
                    ],
                  ),
                )),
                Expanded(
                    child: ReusableCard(
                  cardChild: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "AGE",
                        style: labelTextStyle,
                      ),
                      Text(
                        age.toString(),
                        style: numberStyle,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RoundIconButton(
                              icon: FontAwesomeIcons.minus,
                              onPressed: () => setState(() {
                                    age--;
                                  })),
                          const SizedBox(width: 10),
                          RoundIconButton(
                              icon: FontAwesomeIcons.plus,
                              onPressed: () => setState(() {
                                    age++;
                                  }))
                        ],
                      )
                    ],
                  ),
                ))
              ],
            ),
          ),
          BottomButton(
            text: "CALCULATE",
            onTap: () {
              Calculator c =
                  Calculator(height: height, weight: weight, age: age);

              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ResultsPage(
                        bmiResult: c.calculateBMI(),
                        resultText: c.getResult(),
                        interpretation: c.getInterpretation(),
                        color: c.getColor()),
                  ));
            },
          ),
        ],
      ),
    );
  }
}

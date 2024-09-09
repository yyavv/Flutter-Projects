import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../components//bmi/bottom_button.dart';
import '../components//bmi/icon_content.dart';
import '../components/bmi/reusable_card.dart';
import '../components/bmi/round_icon_button.dart';

const Color activeColor = Color(0xFF1D1E33);
const Color inactiveColor = Color(0xFF111328);
const TextStyle numberStyle =
    TextStyle(fontWeight: FontWeight.w900, fontSize: 50, color: Colors.white);
// 4c4e5e
int height = 175;
int weight = 60;
int age = 25;

enum Gender { male, female }

enum Sign { plus, minus }

class Bmi extends StatefulWidget {
  const Bmi({super.key});

  @override
  State<Bmi> createState() => _BmiState();
}

class _BmiState extends State<Bmi> {
  Gender selectedGender = Gender.male;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0E21),
        title: const Text(
          'Calori Calculator',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFF0A0E21),
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
                    Slider(
                      value: height.toDouble(),
                      onChanged: (double newHeight) {
                        setState(() {
                          height = newHeight.toInt();
                        });
                      },
                      min: 100,
                      max: 220,
                      activeColor: const Color(0xFF80A4ED),
                      inactiveColor: const Color(0xFF8D8E98),
                    )
                  ],
                ),
              ),
            ),
          ),
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
                              onPressed: () => setState(
                                () {
                                  weight++;
                                },
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
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
                            onPressed: () => setState(
                              () {
                                age--;
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          RoundIconButton(
                            icon: FontAwesomeIcons.plus,
                            onPressed: () => setState(
                              () {
                                age++;
                              },
                            ),
                          )
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
              _showInfoDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    double calHB = 0;
    double calMSJ = 0;
    if (selectedGender == Gender.male) {
      calHB = 655.1 + (weight * 13.75) + (height * 5) - (age * 6.77);
      calMSJ = 5 + (weight * 10) + (height * 6.25) - (age * 5);
    } else {
      calHB = 655.1 + (weight * 9.56) + (height * 1.85) - (age * 4.67);
      calMSJ = (-161) + (weight * 10) + (height * 6.25) - (age * 5);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Result',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 22),
          ),
          content: Text(
            'Harris & Benedict Calori Result: ${calHB.toStringAsFixed(2)} \n\n'
            'Miffin & St Jeor Calori Result: ${calMSJ.toStringAsFixed(2)} \n\n'
            'Average Calori: ${((calHB + calMSJ) / 2).toStringAsFixed(2)}',
            style: const TextStyle(
                fontSize: 18,
                color: Color(0xff4B4E5B),
                fontWeight: FontWeight.w500),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
          elevation: 24,
          backgroundColor: Colors.white,
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nutri_change/constants/constants.dart';
import 'package:nutri_change/components/exchange/input_card.dart';
import 'package:nutri_change/components/exchange/nutrition_table.dart';

List<String> elements = [
  'milk',
  'meat',
  'bread',
  'vegetables',
  'fruits',
  'fats oils',
  'nuts',
  'legumes'
];

class ExchangeCalculator extends StatefulWidget {
  const ExchangeCalculator({super.key});

  @override
  State<ExchangeCalculator> createState() => _ExchangeCalculatorState();
}

class _ExchangeCalculatorState extends State<ExchangeCalculator> {
  final List<TextEditingController> controllers =
      List.generate(8, (index) => TextEditingController());

  double cho = 0;
  double protein = 0;
  double fat = 0;
  bool isSemi = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xff00a1ff),
      appBar: AppBar(
        title: const Text(
          'Exchange Calculator',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xff00a1ff),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              for (int i = 0; i < controllers.length; i += 2)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    card(
                      name: elements[i],
                      icon: i == 0
                          ? ((isSemi)
                              ? FontAwesomeIcons.circleHalfStroke
                              : FontAwesomeIcons.solidCircle)
                          : null,
                      iconFunction: i == 0 ? iconToggle : null,
                      controller: controllers[i],
                    ),
                    card(
                        name: elements[i + 1],
                        controller: controllers[i + 1],
                        function: i == 6 ? calculate : null),
                  ],
                ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  buttonExchange(
                      name: 'Clear', color: k_redButtonColor, function: clear),
                  buttonExchange(
                      name: 'Calculate',
                      color: k_greenButtonColor,
                      function: calculate),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              NutritionTable(
                cho: cho,
                protein: protein,
                fat: fat,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void calculate() {
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      // Reset the values
      cho = 0;
      protein = 0;
      fat = 0;

      // milk
      cho += (double.tryParse(controllers[0].text) ?? 0) * 9;
      protein += (double.tryParse(controllers[0].text) ?? 0) * 6;
      isSemi
          ? fat += (double.tryParse(controllers[0].text) ?? 0) * 3
          : fat += (double.tryParse(controllers[0].text) ?? 0) * 6;

      // meat
      protein += (double.tryParse(controllers[1].text) ?? 0) * 6;
      fat += (double.tryParse(controllers[1].text) ?? 0) * 5;

      // bread
      cho += (double.tryParse(controllers[2].text) ?? 0) * 15;
      protein += (double.tryParse(controllers[2].text) ?? 0) * 2;

      // vegetables
      cho += (double.tryParse(controllers[3].text) ?? 0) * 6;
      protein += (double.tryParse(controllers[3].text) ?? 0) * 2;

      // fruits
      cho += (double.tryParse(controllers[4].text) ?? 0) * 15;

      // fats oils
      fat += (double.tryParse(controllers[5].text) ?? 0) * 5;

      // nuts
      protein += (double.tryParse(controllers[6].text) ?? 0) * 2;
      fat += (double.tryParse(controllers[6].text) ?? 0) * 5;

      // legumes
      cho += (double.tryParse(controllers[7].text) ?? 0) * 15;
      protein += (double.tryParse(controllers[7].text) ?? 0) * 5;
    });
  }

  void clear() {
    setState(() {
      for (int i = 0; i < controllers.length; i++) {
        controllers[i].clear();
      }
      cho = 0;
      protein = 0;
      fat = 0;
    });
  }

  void iconToggle() {
    setState(() {
      isSemi ? isSemi = false : isSemi = true;
    });
    showCustomSnackBar();
  }

  void showCustomSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          width: MediaQuery.of(context).size.width *
              0.4, // 40% width of the screen
          alignment: Alignment.center, // Center the text
          child: Text(
            isSemi ? 'Semi Milk' : 'Whole Milk',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior
            .floating, // Makes the snackbar float above other content
        backgroundColor: Colors.grey.shade200, // Light grey background
        elevation: 6, // Subtle shadow for a floating effect
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              12.0), // Rounded corners for a smoother look
        ),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height *
              0.05, // Slightly above the bottom of the screen
          left: MediaQuery.of(context).size.width * 0.3, // Adjust for centering
          right:
              MediaQuery.of(context).size.width * 0.3, // Adjust for centering
        ),
      ),
    );
  }
}

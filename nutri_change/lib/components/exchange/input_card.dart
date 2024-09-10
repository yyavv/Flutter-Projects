import 'package:flutter/material.dart';

SizedBox card(
    {required String name,
    IconData? icon,
    void Function()? iconFunction,
    required TextEditingController controller,
    void Function()? function}) {
  return SizedBox(
    width: 150,
    height: 70,
    child: TextField(
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      controller: controller,
      textInputAction: (function == null)
          ? TextInputAction.next
          : TextInputAction.done, // to move to the next text field
      onSubmitted: (value) {
        if (function != null) {
          function();
        }
      }, // to press enter at the last text field
      decoration: InputDecoration(
        suffixIcon: icon != null
            ? GestureDetector(
                onTap: iconFunction,
                child: Icon(icon),
              )
            : null,
        floatingLabelAlignment: FloatingLabelAlignment.center,
        label: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      ),
    ),
  );
}

// GestureDetector g() {
//   return GestureDetector(
//     onPanUpdate: (details) {
//       // setState(() {
//       //   number -= details.delta.dx / 100;
//       //   number -= details.delta.dy.toInt();
//       //   number = double.parse(number.toStringAsFixed(2));
//       // });
//     },
//     child: Container(
//       height: 60,
//       width: 120,
//       decoration: BoxDecoration(
//           borderRadius: BorderRadiusDirectional.circular(10),
//           color: Colors.blue),
//       child: Center(
//           child: Text(
//         '',
//         //'$number',
//         style: const TextStyle(
//             fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
//       )),
//     ),
//   );
// }

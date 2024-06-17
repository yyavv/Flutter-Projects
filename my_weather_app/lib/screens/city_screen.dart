import 'package:flutter/material.dart';

class CityScreen extends StatefulWidget {
  const CityScreen({super.key});

  @override
  State<CityScreen> createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  String? cityName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF13262F),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(30),
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextField(
                onChanged: (city) {
                  cityName = city;
                },
                decoration: InputDecoration(
                  icon: const Icon(
                    Icons.search_rounded,
                    color: Colors.white,
                  ),
                  hintText: 'Enter City Name',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, cityName);
                },
                style: TextButton.styleFrom(
                    backgroundColor: const Color(0xff56445D)),
                child: const Padding(
                  padding: EdgeInsets.only(right: 15, left: 15),
                  child: Text(
                    'Get Weather',
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

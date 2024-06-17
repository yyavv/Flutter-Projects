import 'package:flutter/material.dart';
import 'package:my_weather_app/services/weather.dart';

import 'city_screen.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({super.key, required this.weatherData});
  dynamic weatherData;

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weatherModel = WeatherModel();
  int temperature = 0;
  String cityName = '';
  String status = 'Unable to get weather data';
  int condition = 1000;

  @override
  void initState() {
    super.initState();
    updateUI(widget.weatherData);
  }

  void updateUI(dynamic weatherData) {
    if (weatherData != null) {
      setState(() {
        double temp = weatherData['main']['temp'];
        temperature = temp.toInt();
        cityName = weatherData['name'];
        status = weatherData['weather'][0]['description'];
        condition = weatherData['weather'][0]['id'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF13262F),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          TextButton(
            onPressed: () async {
              var weatherData = await weatherModel.getCurrentWeather();
              updateUI(weatherData);
            },
            child: const Icon(
              Icons.near_me_outlined,
              size: 30.0,
              color: Colors.white,
            ),
          ),
          TextButton(
            onPressed: () async {
              dynamic typedName = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return const CityScreen();
                  },
                ),
              );
              if (typedName != null) {
                dynamic weatherData =
                    await weatherModel.getCityWeather(typedName);
                print(typedName);
                updateUI(weatherData);
              }
            },
            child: const Icon(
              Icons.location_on_outlined,
              size: 30.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                cityName,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '$temperature°C',
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                status,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              weatherModel.getIcon(condition),
            ],
          ),
        ),
      ),
    );
  }
}

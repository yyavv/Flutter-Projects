import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_weather_app/services/networking.dart';
import 'location.dart';

const String apiKey = '269920a84e84e1e06a08863a629aeb41';

class WeatherModel {
  Future<dynamic> getCityWeather(String cityName) async {
    dynamic weatherData = await NetworkHelper(
            url:
                'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric')
        .getData();

    return weatherData;
  }

  Future<dynamic> getCurrentWeather() async {
    Location location = Location();
    await location.getCurrentLocation();

    dynamic weatherData = await NetworkHelper(
            url:
                'https://api.openweathermap.org/data/2.5/weather?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric')
        .getData();

    return weatherData;
  }

  Icon getIcon(int condition) {
    IconData iconData;

    if (condition < 300) {
      iconData = CupertinoIcons.tropicalstorm;
    } else if (condition < 400) {
      iconData = CupertinoIcons.cloud_rain;
    } else if (condition < 600) {
      iconData = CupertinoIcons.cloud_heavyrain;
    } else if (condition < 700) {
      iconData = CupertinoIcons.snow;
    } else if (condition < 800) {
      iconData = Icons.foggy;
    } else if (condition == 800) {
      iconData = CupertinoIcons.sun_max;
    } else if (condition <= 804) {
      iconData = Icons.cloud;
    } else {
      iconData = CupertinoIcons.xmark;
    }

    return Icon(
      iconData,
      color: Colors.white,
      size: 120,
    );
  }
}

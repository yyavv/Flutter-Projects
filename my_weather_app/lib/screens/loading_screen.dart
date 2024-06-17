import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:my_weather_app/services/weather.dart';
import 'package:permission_handler/permission_handler.dart';
import 'location_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    checkPermissions();
  }

  Future<void> checkPermissions() async {
    PermissionStatus permission = await Permission.location.request();

    if (permission.isGranted) {
      // Permission granted, you can access the location
      var weatherData = await WeatherModel().getCurrentWeather();

      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return LocationScreen(weatherData: weatherData);
      }));
    } else if (permission.isDenied) {
      // Permission denied, show a message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location permission denied'),
        ),
      );
    } else if (permission.isPermanentlyDenied) {
      // Permission permanently denied, open app settings
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF13262F),
      body: Center(
        child: SpinKitThreeBounce(
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}

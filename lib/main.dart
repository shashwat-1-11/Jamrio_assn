import 'package:flutter/material.dart';
import 'weather_model.dart';
import 'weather_service.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Forecast App',
      home: WeatherScreen(),
    );
  }
}

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  late Future<List<Weather>> _weatherForecast;
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set default latitude and longitude (replace with your values)
    _latitudeController.text = '33.44';
    _longitudeController.text = '-94.04';
    _weatherForecast = _weatherService.getWeatherForecast(
      double.parse(_latitudeController.text),
      double.parse(_longitudeController.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Forecast'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _latitudeController,
              decoration: InputDecoration(labelText: 'Latitude'),
            ),
            TextField(
              controller: _longitudeController,
              decoration: InputDecoration(labelText: 'Longitude'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _weatherForecast = _weatherService.getWeatherForecast(
                    double.parse(_latitudeController.text),
                    double.parse(_longitudeController.text),
                  );
                });
              },
              child: Text('Get Weather'),
            ),
            SizedBox(height: 16.0),
            FutureBuilder<List<Weather>>(
              future: _weatherForecast,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No weather data available');
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final weather = snapshot.data![index];
                        return ListTile(
                          title: Text('Date: ${weather.date.toLocal()}'),
                          subtitle: Text(
                            'Temperature: ${weather.temperature.toStringAsFixed(1)}°C\nCondition: ${weather.condition}\nHumidity: ${weather.humidity}%',
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

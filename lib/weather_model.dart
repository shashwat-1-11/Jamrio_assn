class Weather {
  final DateTime date;
  final double temperature;
  final String condition;
  final int humidity;

  Weather({
    required this.date,
    required this.temperature,
    required this.condition,
    required this.humidity,
  });

  factory Weather.fromHourlyJson(Map<String, dynamic> json) {
    return Weather(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: json['temp'].toDouble(),
      condition: json['weather'][0]['description'],
      humidity: json['humidity'],
    );
  }
}

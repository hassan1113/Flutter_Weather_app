import 'package:intl/intl.dart';

class Weather {
  final String cityName;
  final String description;
  final String temperature;
  final String humidity;
  final String windSpeed;
  final String iconUrl;
  final String localTime;

  Weather({
    required this.cityName,
    required this.description,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.iconUrl,
    required this.localTime,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    final timezoneOffset = json['timezone'];
    final nowUtc = DateTime.now().toUtc();
    final localTime = nowUtc.add(Duration(seconds: timezoneOffset));
    return Weather(
      cityName: json['name'],
      description: json['weather'][0]['description'],
      temperature: json['main']['temp'].toString(),
      humidity: json['main']['humidity'].toString(),
      windSpeed: json['wind']['speed'].toString(),
      iconUrl: 'https://openweathermap.org/img/wn/${json['weather'][0]['icon']}@2x.png',
      localTime: DateFormat.jm().format(localTime),
    );
  }
}

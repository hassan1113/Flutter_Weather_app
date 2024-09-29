import 'package:flutter/material.dart';
import 'package:weather_app/weathermodel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Import the intl package for date formatting

class WeatherHomePage extends StatefulWidget {
  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  late Future<Weather> futureWeather;
  final TextEditingController _controller = TextEditingController();
  String cityName = 'Karachi'; // Default city

  @override
  void initState() {
    super.initState();
    futureWeather = fetchWeather(cityName);
  }

  Future<Weather> fetchWeather(String city) async {
    final apiKey = '85fb13096b836956e91e08354be43f39';
    final response = await http.get(Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  void searchCity() {
    setState(() {
      cityName = _controller.text;
      futureWeather = fetchWeather(cityName);
    });
    _controller.clear(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset("assets/images/weather.png", width: 40, height: 40),
            SizedBox(width: 10),
            Text('Weather Wise', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter city name',
                suffixIcon: IconButton(
                  iconSize: 25,
                  color: Colors.blue,
                  splashRadius: 20,
                  splashColor: Colors.transparent,
                  icon: Icon(Icons.search),
                  onPressed: searchCity,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: FutureBuilder<Weather>(
                  future: futureWeather,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final weather = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [Colors.blue, Colors.blue[800]!]),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  weather.cityName,
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  weather.localTime,
                                  style: TextStyle(fontSize: 16, color: Colors.white70, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5),
                                // Displaying Date
                                Text(
                                  DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now()),
                                  style: TextStyle(fontSize: 16, color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30),
                          Center(
                            child: Column(
                              children: [
                                Image.network(
                                  weather.iconUrl,
                                  width: 100,
                                  height: 100,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '${weather.temperature}°C',
                                  style: TextStyle(
                                    fontSize: 60,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  weather.description.toUpperCase(),
                                  style: TextStyle(fontSize: 24, color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              weatherInfo(Icons.opacity, 'Humidity', '${weather.humidity}%'),
                              weatherInfo(Icons.air, 'Wind', '${weather.windSpeed} km/h'),
                              weatherInfo(Icons.cloud, 'Cloudiness', '20%'), 
                            ],
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget weatherInfo(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 30, color: Colors.blue),
        SizedBox(height: 10),
        Text(
          value,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(label),
      ],
    );
  }
}

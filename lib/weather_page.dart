
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // TODO: Add your OpenWeatherMap API key here
  final String _weatherApiKey = 'YOUR_OPENWEATHERMAP_API_KEY';
  // TODO: Add your Gemini API key here
  final String _geminiApiKey = 'YOUR_GEMINI_API_KEY';

  String _location = 'Loading...';
  String _temperature = '';
  String _feelsLike = '';
  String _humidity = '';
  String _windSpeed = '';
  String _uvIndex = '';
  String _rainChance = '';
  String _aiAdvice = 'Loading advice...';
  List<dynamic> _forecast = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      Position position = await _determinePosition();
      final weatherResponse = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$_weatherApiKey&units=metric'));
      final forecastResponse = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?lat=${position.latitude}&lon=${position.longitude}&appid=$_weatherApiKey&units=metric'));

      if (weatherResponse.statusCode == 200 && forecastResponse.statusCode == 200) {
        final weatherData = json.decode(weatherResponse.body);
        final forecastData = json.decode(forecastResponse.body);

        setState(() {
          _location = weatherData['name'];
          _temperature = weatherData['main']['temp'].toString();
          _feelsLike = weatherData['main']['feels_like'].toString();
          _humidity = weatherData['main']['humidity'].toString();
          _windSpeed = weatherData['wind']['speed'].toString();
          _uvIndex = 'N/A'; // OpenWeatherMap free tier doesn't provide UV index
          _rainChance = (forecastData['list'][0]['pop'] * 100).toStringAsFixed(0);
          _forecast = forecastData['list'];
          _isLoading = false;
        });
        _fetchAiAdvice();
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchAiAdvice() async {
    final model = GenerativeModel(model: 'gemini-pro', apiKey: _geminiApiKey);
    final prompt =
        'Given the weather conditions: temperature $_temperature°C, humidity $_humidity%, wind speed $_windSpeed km/h, and a $_rainChance% chance of rain, what is your farming advice for the day?';
    try {
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      setState(() {
        _aiAdvice = response.text ?? 'No advice generated.';
      });
    } catch (e) {
      setState(() {
        _aiAdvice = 'Failed to get AI advice.';
      });
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text('Error: $_errorMessage'))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLiveWeatherCard(),
                        const SizedBox(height: 24),
                        _buildCurrentConditionsCard(),
                        const SizedBox(height: 24),
                        const Text(
                          'Extended Weather Forecast',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        _buildForecast(),
                        const SizedBox(height: 24),
                        _buildImpactAnalysis(),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildLiveWeatherCard() {
    return Card(
      color: Colors.blue.shade300,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Live Weather for $_location',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Real-time satellite-powered weather intelligence',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: _fetchWeatherData,
                  icon: const Icon(Icons.refresh, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentConditionsCard() {
    return Card(
      color: Colors.lightBlue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.wb_sunny, size: 40, color: Colors.orange),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Current Conditions', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(_location),
                  ],
                ),
                const Spacer(),
                Text(
                  '$_temperature°C',
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Text('Feels like $_feelsLike°C'),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                WeatherDetail(icon: Icons.water_drop, value: '$_humidity%', label: 'Humidity'),
                WeatherDetail(icon: Icons.cloudy_snowing, value: '$_rainChance%', label: 'Rain Chance'),
                WeatherDetail(icon: Icons.air, value: '$_windSpeed km/h', label: 'Wind Speed'),
                WeatherDetail(icon: Icons.visibility, value: _uvIndex, label: 'UV Index'),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              color: Colors.green.shade100,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('Live Farming Advice\n$_aiAdvice'),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildForecast() {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _forecast.length,
        itemBuilder: (context, index) {
          final item = _forecast[index];
          return ForecastCard(
            day: DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000).toString(),
            temp: '${item['main']['temp']}°C',
            rain: '${(item['pop'] * 100).toStringAsFixed(0)}%',
            humidity: '${item['main']['humidity']}%',
          );
        },
      ),
    );
  }

  Widget _buildImpactAnalysis() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AI Farming Advisor',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(_aiAdvice),
          ],
        ),
      ),
    );
  }
}

class WeatherDetail extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const WeatherDetail({super.key, required this.icon, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue.shade700),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class ForecastCard extends StatelessWidget {
  final String day;
  final String temp;
  final String rain;
  final String humidity;

  const ForecastCard({
    super.key,
    required this.day,
    required this.temp,
    required this.rain,
    required this.humidity,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(day, style: const TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            const Icon(Icons.wb_sunny, color: Colors.orange),
            const Spacer(),
            Text('Temperature: $temp'),
            Text('Rain Chance: $rain'),
            Text('Humidity: $humidity'),
          ],
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:farm_flow/location_service.dart';

class IrrigationPage extends StatefulWidget {
  const IrrigationPage({super.key});

  @override
  _IrrigationPageState createState() => _IrrigationPageState();
}

class _IrrigationPageState extends State<IrrigationPage> {
  final String _openWeatherApiKey = "296923fadda6cb9bd560d4e8288ec552";
  final String _nasaApiKey = "6yBIlI2XSXRu18s37nMcypJ4LPR2Z3Tr3scqjsD1";
  final String _tomorrowApiKey = "YzWGCyy3iIjeBa2e0zDFgGbqmJbBiopq";

  String _city = "Delhi";
  Position? _currentPosition;
  Map<String, dynamic>? _openWeatherData;
  Map<String, dynamic>? _nasaPowerData;
  Map<String, dynamic>? _tomorrowData;
  String? _recommendation;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchAllData();
  }

  Future<void> _fetchAllData() async {
    setState(() => _isLoading = true);

    try {
      // ✅ Use LocationService
      _currentPosition = await LocationService().getCurrentLocation();

      if (_currentPosition != null) {
        final openWeatherData = await _fetchOpenWeatherData();
        final nasaPowerData = await _fetchNasaPowerData();
        final tomorrowData = await _fetchTomorrowData();

        setState(() {
          _openWeatherData = openWeatherData;
          _nasaPowerData = nasaPowerData;
          _tomorrowData = tomorrowData;
          if (openWeatherData != null) {
            _city = openWeatherData['name'];
          }
          _generateRecommendation(openWeatherData, tomorrowData);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print("Error fetching data: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<Map<String, dynamic>?> _fetchOpenWeatherData() async {
    if (_currentPosition == null) return null;
    final lat = _currentPosition!.latitude;
    final lon = _currentPosition!.longitude;

    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$_openWeatherApiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return null;
  }

  Future<Map<String, dynamic>?> _fetchNasaPowerData() async {
    if (_currentPosition == null) return null;
    final lat = _currentPosition!.latitude;
    final lon = _currentPosition!.longitude;

    final endDate = DateTime.now();
    final startDate = endDate.subtract(const Duration(days: 7));

    final url =
        'https://power.larc.nasa.gov/api/temporal/daily/point?parameters=T2M,RH2M&community=AG&longitude=$lon&latitude=$lat&start=${startDate.year}${startDate.month.toString().padLeft(2, '0')}${startDate.day.toString().padLeft(2, '0')}&end=${endDate.year}${endDate.month.toString().padLeft(2, '0')}${endDate.day.toString().padLeft(2, '0')}&format=JSON&api_key=$_nasaApiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return null;
  }

  Future<Map<String, dynamic>?> _fetchTomorrowData() async {
    if (_currentPosition == null) return null;
    final lat = _currentPosition!.latitude;
    final lon = _currentPosition!.longitude;

    final url =
        'https://api.tomorrow.io/v4/weather/realtime?location=$lat,$lon&apikey=$_tomorrowApiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return null;
  }

  void _generateRecommendation(
      Map<String, dynamic>? openWeatherData, Map<String, dynamic>? tomorrowData) {
    if (openWeatherData == null || tomorrowData == null) {
      _recommendation =
      "Could not fetch all weather data to make a recommendation.";
      return;
    }

    final temp = openWeatherData['main']['temp'];
    final humidity = openWeatherData['main']['humidity'];
    final precipitation =
        tomorrowData['data']['values']['precipitationIntensity'] ?? 0;

    if (precipitation > 0) {
      _recommendation = "It has rained recently. No need to irrigate.";
    } else if (temp > 30 && humidity < 40) {
      _recommendation =
      "High temperature and low humidity. It's a good time to irrigate your crops.";
    } else {
      _recommendation =
      "Weather conditions are moderate. Check soil moisture for irrigation needs.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Irrigation'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Location: $_city',
                style: Theme.of(context).textTheme.headlineSmall),
            if (_recommendation != null)
              Card(
                color: Colors.blue.shade100,
                child: ListTile(
                  leading: Icon(Icons.lightbulb_outline,
                      color: Colors.blue.shade900),
                  title: Text('Recommendation',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade900)),
                  subtitle: Text(_recommendation!,
                      style: TextStyle(color: Colors.blue.shade800)),
                ),
              ),
            if (_openWeatherData != null)
              Card(
                child: ListTile(
                  title: const Text('OpenWeather'),
                  subtitle: Text(
                      'Temperature: ${_openWeatherData!['main']['temp']}°C\n'
                          'Humidity: ${_openWeatherData!['main']['humidity']}%'),
                ),
              ),
            if (_tomorrowData != null)
              Card(
                child: ListTile(
                  title: const Text('Tomorrow.io'),
                  subtitle: Text(
                      'Temperature: ${_tomorrowData!['data']['values']['temperature']}°C\n'
                          'Humidity: ${_tomorrowData!['data']['values']['humidity']}%'),
                ),
              ),
            if (_nasaPowerData != null)
              Card(
                child: ExpansionTile(
                  title: const Text('NASA POWER Data (Last 7 days)'),
                  children: [
                    for (final entry in _nasaPowerData!['properties']
                    ['parameter']['T2M']
                        .entries)
                      ListTile(
                        title: Text('Date: ${entry.key}'),
                        subtitle: Text(
                            'Temperature: ${entry.value}°C\n'
                                'Humidity: ${_nasaPowerData!['properties']['parameter']['RH2M'][entry.key]}%'),
                      )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

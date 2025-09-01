import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherPage extends StatefulWidget {
  final String? crop; // ✅ accept crop from dashboard

  const WeatherPage({super.key, this.crop});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  String city = "Delhi";
  String apiKey = "86976125e888ae5d3c3d358a0724306a"; // 🔑 Replace with your OpenWeather API key
  Map<String, dynamic>? weatherData;
  String? weatherAlert;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  Future<void> fetchWeather() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric"));

      if (response.statusCode == 200) {
        setState(() {
          weatherData = json.decode(response.body);
          weatherAlert = getWeatherAlert(weatherData!);
          isLoading = false;
        });
      } else {
        setState(() {
          weatherData = null;
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("⚠️ Couldn’t fetch weather for $city")),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Error fetching weather data")),
      );
    }
  }

  String? getWeatherAlert(Map<String, dynamic> data) {
    final condition = data["weather"][0]["main"].toString().toLowerCase();
    if (condition.contains("rain")) {
      return "🌧️ Rain expected. Protect your crops!";
    } else if (condition.contains("storm")) {
      return "⛈️ Storm alert. Take precautions!";
    } else if (condition.contains("heat")) {
      return "🔥 High temperature! Ensure crops are watered.";
    }
    return null;
  }

  String getFarmerTip() {
    if (weatherAlert != null) {
      return "⚠️ Based on current weather, take preventive measures for your farm.";
    } else {
      if (widget.crop != null) {
        return "✅ Weather looks good for growing ${widget.crop}. Continue regular farming practices.";
      }
      return "✅ Weather is good. Continue regular farming practices.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.crop != null
            ? "🌦 Weather - ${widget.crop}"
            : "🌦 Weather Updates"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchWeather,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔍 City Search Box
            TextField(
              decoration: InputDecoration(
                labelText: "Enter City",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  setState(() => city = value);
                  fetchWeather();
                }
              },
            ),
            const SizedBox(height: 20),

            // 📊 Weather Info
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : weatherData == null
                  ? const Center(
                child: Text("❌ No weather data available"),
              )
                  : ListView(
                children: [
                  _buildWeatherCard(
                    "📍 City",
                    city,
                    Icons.location_on,
                    Colors.blue,
                  ),
                  const SizedBox(height: 16),
                  _buildWeatherCard(
                    "🌡 Temperature",
                    "${weatherData!["main"]["temp"]}°C",
                    Icons.thermostat,
                    Colors.red,
                  ),
                  const SizedBox(height: 16),
                  _buildWeatherCard(
                    "☁ Condition",
                    weatherData!["weather"][0]["main"],
                    Icons.cloud,
                    Colors.grey,
                  ),

                  const SizedBox(height: 20),

                  // ⚠ Weather Alert
                  if (weatherAlert != null)
                    Card(
                      color: Colors.red[100],
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          weatherAlert!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // 👨‍🌾 Farmer Tip
                  Card(
                    color: Colors.green[100],
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        getFarmerTip(),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Reusable card builder
  Widget _buildWeatherCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                "$title: $value",
                style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

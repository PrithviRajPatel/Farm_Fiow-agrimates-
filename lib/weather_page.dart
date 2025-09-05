import 'package:flutter/material.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Weather', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Real-time farming intelligence', style: TextStyle(fontSize: 12)),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.agriculture),
            label: const Text('Agribot AI'),
            style: TextButton.styleFrom(foregroundColor: Colors.black),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.language),
            label: const Text('us English'),
            style: TextButton.styleFrom(foregroundColor: Colors.black),
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Live Weather for Punjab, India',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Real-time satellite-powered weather intelligence',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.refresh, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Live updates • Last refreshed: 1:57:20 AM', style: TextStyle(color: Colors.white70)),
                const Spacer(),
                Chip(
                  label: const Text('Auto-refresh: 5 min'),
                  backgroundColor: Colors.white.withOpacity(0.3),
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
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Current Conditions', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('Punjab, India'),
                  ],
                ),
                const Spacer(),
                const Text(
                  '32°C',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                const Text('Feels like 34°C'),
              ],
            ),
            const SizedBox(height: 24),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                WeatherDetail(icon: Icons.water_drop, value: '66%', label: 'Humidity'),
                WeatherDetail(icon: Icons.cloudy_snowing, value: '39%', label: 'Rain Chance'),
                WeatherDetail(icon: Icons.air, value: '3 km/h', label: 'Wind Speed'),
                WeatherDetail(icon: Icons.visibility, value: '1', label: 'UV Index'),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              color: Colors.green.shade100,
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text('Live Farming Advice\nFavorable conditions for farming activities'),
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
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: const [
          ForecastCard(day: 'Today', temp: '32°C', rain: '39%', humidity: '66%'),
          ForecastCard(day: 'Thu, Sep 4', temp: '32°C', rain: '39%', humidity: '66%', expectedRain: '8mm'),
          ForecastCard(day: 'Fri, Sep 5', temp: '32°C', rain: '0%', humidity: '66%'),
          ForecastCard(day: 'Sat, Sep 6', temp: '32°C', rain: '0%', humidity: '66%'),
        ],
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
              'Live Agricultural Impact Analysis',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Real-time Insights', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      _buildInsightItem(Colors.green, 'Current conditions updated every 5 minutes'),
                      _buildInsightItem(Colors.blue, 'ISRO satellite data integration active'),
                      _buildInsightItem(Colors.orange, 'AI-powered farming recommendations'),
                      _buildInsightItem(Colors.purple, 'Automatic irrigation adjustments'),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Smart Actions', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      _buildActionItem(Icons.decision, 'AI Decision: Normal irrigation schedule active'),
                      _buildActionItem(Icons.notification_important, 'Alerts: Weather conditions normal'),
                      _buildActionItem(Icons.water, 'Water Management: Optimizing based on live humidity data'),
                      _buildActionItem(Icons.pest_control, 'Crop Care: Monitoring pest risk from weather conditions'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightItem(Color color, String text) {
    return Row(
      children: [
        Icon(Icons.circle, color: color, size: 8),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    );
  }

  Widget _buildActionItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
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
  final String? expectedRain;

  const ForecastCard({
    super.key,
    required this.day,
    required this.temp,
    required this.rain,
    required this.humidity,
    this.expectedRain,
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
            if (expectedRain != null) Text('Expected Rain: $expectedRain'),
          ],
        ),
      ),
    );
  }
}

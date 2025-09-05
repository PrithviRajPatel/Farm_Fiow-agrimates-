import 'package:farm_flow/ai_assistant_page.dart';
import 'package:farm_flow/ai_recommendations_page.dart';
import 'package:farm_flow/market_rates_page.dart';
import 'package:farm_flow/plant_health_page.dart';
import 'package:farm_flow/sensors_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:farm_flow/controls_page.dart';

class DashboardPage extends StatefulWidget {
  final List<String> crops;
  const DashboardPage({super.key, required this.crops});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  final List<String> _pageTitles = [
    'Dashboard',
    'Sensors',
    'Weather',
    'AI Recommendations',
    'Plant Health',
    'AI Assistant',
    'Market Rates',
    'Controls',
    'Settings',
  ];

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomePage(),
      const SensorsPage(),
      const WeatherPage(),
      AIRecommendationsPage(crops: widget.crops),
      const PlantHealthPage(),
      const AIAssistantPage(),
      const MarketRatesPage(),
      const ControlsPage(),
      const SettingsPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_selectedIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Text(
                'AgriMates',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.sensors),
              title: const Text('Sensors'),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.wb_sunny),
              title: const Text('Weather'),
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.lightbulb),
              title: const Text('AI Recommendations'),
              onTap: () {
                setState(() {
                  _selectedIndex = 3;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_florist),
              title: const Text('Plant Health'),
              onTap: () {
                setState(() {
                  _selectedIndex = 4;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.assistant),
              title: const Text('AI Assistant'),
              onTap: () {
                setState(() {
                  _selectedIndex = 5;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.show_chart),
              title: const Text('Market Rates'),
              onTap: () {
                setState(() {
                  _selectedIndex = 6;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_remote),
              title: const Text('Controls'),
              onTap: () {
                setState(() {
                  _selectedIndex = 7;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                setState(() {
                  _selectedIndex = 8;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseReference _sensorsRef = FirebaseDatabase.instance.ref('sensors');
  final DatabaseReference _recommendationsRef = FirebaseDatabase.instance.ref('recommendations');

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to AgriMates',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your intelligent farming companion is monitoring your crops 24/7',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            StreamBuilder(
              stream: _sensorsRef.onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (snapshot.hasData && !snapshot.hasError && snapshot.data!.snapshot.value != null) {
                  final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                  final sensors = data.values.toList();
                  final soilMoisture = sensors.firstWhere((s) => s['name'] == 'Soil Moisture', orElse: () => null);
                  final temperature = sensors.firstWhere((s) => s['name'] == 'Temperature', orElse: () => null);
                  final npk = sensors.firstWhere((s) => s['name'] == 'Npk', orElse: () => null);

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildStatCard('Soil Moisture', soilMoisture != null ? soilMoisture['value'] : 'N/A', '+5%'),
                      _buildStatCard('Temperature', temperature != null ? temperature['value'] : 'N/A', '-2%'),
                      _buildStatCard('NPK Levels', npk != null ? npk['value'] : 'N/A', '+8%'),
                      _buildStatCard('Power Level', '87%', '0%'),
                    ],
                  );
                } else {
                  return const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 24),
            _buildWeatherCard(),
            const SizedBox(height: 24),
            _buildSmartIrrigationCard(),
            const SizedBox(height: 24),
            StreamBuilder(
              stream: _recommendationsRef.onValue,
              builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
                if (snapshot.hasData && !snapshot.hasError && snapshot.data!.snapshot.value != null) {
                  final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
                  final recommendations = data.values.toList();
                  final highPriorityRecommendation = recommendations.firstWhere((r) => r['priority'] == 'High', orElse: () => null);
                  return _buildAIRecommendationsCard(highPriorityRecommendation);
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, String change) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(title),
              const SizedBox(height: 8),
              Text(
                value,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(change),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ISRO Weather Data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  children: [
                    Text('33°C',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    Text('Temperature'),
                  ],
                ),
                const Column(
                  children: [
                    Text('60%',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    Text('Rain Chance'),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.water_drop),
                        const Text('80%'),
                      ],
                    ),
                    const Text('Humidity'),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.air),
                        const Text('9km/h'),
                      ],
                    ),
                    const Text('Wind'),
                  ],
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.wb_sunny),
                        const Text('3'),
                      ],
                    ),
                    const Text('UV Index'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Rain expected - Irrigation automatically paused'),
          ],
        ),
      ),
    );
  }

  Widget _buildSmartIrrigationCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Smart Irrigation',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  children: [
                    Text('Next Run'),
                    Text('Duration'),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Start Now'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIRecommendationsCard(dynamic recommendation) {
    if (recommendation == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('No high priority recommendations at the moment.'),
        ),
      );
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AI Recommendations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(recommendation['title'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(recommendation['description'] ?? ''),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {},
              child: const Text('View Details'),
            ),
          ],
        ),
      ),
    );
  }
}

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Weather Page'));
  }
}

class ControlsPage extends StatelessWidget {
  const ControlsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Controls Page'));
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Settings Page'));
  }
}


import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class SensorsPage extends StatefulWidget {
  const SensorsPage({super.key});

  @override
  State<SensorsPage> createState() => _SensorsPageState();
}

class _SensorsPageState extends State<SensorsPage> {
  final DatabaseReference _sensorsRef = FirebaseDatabase.instance.ref('sensors');
  final String _geminiApiKey = 'YOUR_GEMINI_API_KEY'; // TODO: Add your Gemini API key
  String _aiAdvice = 'Loading advice...';

  @override
  void initState() {
    super.initState();
    _fetchAiAdvice();
  }

  Future<void> _fetchAiAdvice() async {
    final model = GenerativeModel(model: 'gemini-pro', apiKey: _geminiApiKey);
    final snapshot = await _sensorsRef.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      final prompt =
          'Given the following sensor readings: $data, what are your farming recommendations?';
      try {
        final content = [Content.text(prompt)];
        final response = await model.generateContent(content);
        if (mounted) {
          setState(() {
            _aiAdvice = response.text ?? 'No advice generated.';
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _aiAdvice = 'Failed to get AI advice.';
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sensors'),
      ),
      body: StreamBuilder(
        stream: _sensorsRef.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasData &&
              !snapshot.hasError &&
              snapshot.data!.snapshot.value != null) {
            final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            final sensors = data.values.toList();

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLiveSensorDataCard(),
                    const SizedBox(height: 24),
                    _buildSensorGrid(sensors),
                    const SizedBox(height: 24),
                    _buildAiAdviceCard(),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildLiveSensorDataCard() {
    return Card(
      color: Colors.deepPurple.shade300,
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Live Sensor Data',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Real-time monitoring of your farm conditions',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorGrid(List<dynamic> sensors) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: sensors.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final sensor = sensors[index];
        return SensorCard(
          name: sensor['name'],
          value: sensor['value'],
          status: sensor['status'],
        );
      },
    );
  }

  Widget _buildAiAdviceCard() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AI Farming Advisor',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 16),
            Text(_aiAdvice),
          ],
        ),
      ),
    );
  }
}

class SensorCard extends StatelessWidget {
  final String name;
  final String value;
  final String status;

  const SensorCard({
    super.key,
    required this.name,
    required this.value,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: status == 'warning' ? Colors.yellow.shade100 : Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            Chip(
              label: Text(status),
              backgroundColor: status == 'warning' ? Colors.orange : Colors.green,
              labelStyle: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

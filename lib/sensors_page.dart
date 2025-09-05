import 'package:flutter/material.dart';

class SensorsPage extends StatelessWidget {
  const SensorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sensors', style: TextStyle(fontWeight: FontWeight.bold)),
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
              _buildLiveSensorDataCard(),
              const SizedBox(height: 24),
              _buildSensorGrid(),
              const SizedBox(height: 24),
              const Text(
                'Recent Sensor History',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildSensorHistory(),
            ],
          ),
        ),
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
            SizedBox(height: 16),
            Text('All sensors online • Last updated: 2:09:44 AM', style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  Widget _buildSensorGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: const [
        SensorCard(name: 'Npk', field: 'Field B', value: '45%', status: 'warning'),
        SensorCard(name: 'Temperature', field: 'Field B', value: '32°C', status: 'normal'),
        SensorCard(name: 'Soil Moisture', field: 'Field B', value: '28%', status: 'warning'),
        SensorCard(name: 'Ph', field: 'Field A', value: '6.8 pH', status: 'normal'),
        SensorCard(name: 'Water Level', field: 'Tank A', value: '78%', status: 'normal'),
        SensorCard(name: 'Humidity', field: 'Field A', value: '65%', status: 'normal'),
        SensorCard(name: 'Light', field: 'Field A', value: '85%', status: 'normal'),
      ],
    );
  }

  Widget _buildSensorHistory() {
    return Card(
      child: Column(
        children: const [
          SensorHistoryTile(name: 'Npk - Field B', date: '8/27/2025, 6:19:37 PM', value: '45%', status: 'warning'),
          SensorHistoryTile(name: 'Temperature - Field B', date: '8/27/2025, 6:19:37 PM', value: '32°C', status: 'normal'),
          SensorHistoryTile(name: 'Soil Moisture - Field B', date: '8/27/2025, 6:19:37 PM', value: '28%', status: 'warning'),
          SensorHistoryTile(name: 'Ph - Field A', date: '8/27/2025, 6:19:37 PM', value: '6.8 pH', status: 'normal'),
        ],
      ),
    );
  }
}

class SensorCard extends StatelessWidget {
  final String name;
  final String field;
  final String value;
  final String status;

  const SensorCard({
    super.key,
    required this.name,
    required this.field,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Chip(
                  label: Text(status),
                  backgroundColor: status == 'warning' ? Colors.orange : Colors.green,
                  labelStyle: const TextStyle(color: Colors.white),
                ),
              ],
            ),
            Text(field),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            const Text('Last Updated: 6:19:37 PM'),
            Text('Location: $field'),
            if (status == 'warning')
              const Chip(
                label: Text('Monitor closely'),
                avatar: Icon(Icons.warning, size: 16),
              ),
          ],
        ),
      ),
    );
  }
}

class SensorHistoryTile extends StatelessWidget {
  final String name;
  final String date;
  final String value;
  final String status;

  const SensorHistoryTile({
    super.key,
    required this.name,
    required this.date,
    required this.value,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.history),
      title: Text(name),
      subtitle: Text(date),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          Chip(
            label: Text(status),
            backgroundColor: status == 'warning' ? Colors.orange : Colors.green,
            labelStyle: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

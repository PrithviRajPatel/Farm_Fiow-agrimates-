import 'package:flutter/material.dart';

class ControlsPage extends StatelessWidget {
  const ControlsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Controls', style: TextStyle(fontWeight: FontWeight.bold)),
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
              _buildSystemControlsCard(),
              const SizedBox(height: 24),
              _buildManualIrrigationControls(),
              const SizedBox(height: 24),
              _buildIrrigationSchedule(),
              const SizedBox(height: 24),
              _buildEmergencyControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSystemControlsCard() {
    return Card(
      color: Colors.deepPurple.shade300,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'System Controls',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Manage your smart farming systems and schedules',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 3,
              children: [
                _buildControlToggle('Irrigation System', true),
                _buildControlToggle('AI Automation', true),
                _buildControlToggle('Sensor Network', true),
                _buildControlToggle('Weather Sync', true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlToggle(String title, bool value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Switch(value: value, onChanged: (val) {}),
          ],
        ),
      ),
    );
  }

  Widget _buildManualIrrigationControls() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Manual Irrigation Controls',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildFieldControl('Field A'),
                _buildFieldControl('Field B'),
                _buildFieldControl('Field C'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldControl(String fieldName) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(fieldName, style: const TextStyle(fontWeight: FontWeight.bold)),
            const Chip(label: Text('Scheduled')),
            const Text('Next Run: 06:30 AM'),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.stop),
                  label: const Text('Stop'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIrrigationSchedule() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Irrigation Schedule',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Schedule'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildScheduleItem(
              field: 'Field B',
              time: '1/22/2024, 5:45:00 AM',
              duration: '0 min',
              water: '0L',
              type: 'AI Generated',
              reason: 'Rain forecast - irrigation postponed',
              status: 'Skipped',
            ),
            _buildScheduleItem(
              field: 'Field C',
              time: '1/21/2024, 7:00:00 AM',
              duration: '25 min',
              water: '320L',
              type: 'Manual',
              reason: 'Regular maintenance irrigation',
              status: 'Scheduled',
              actions: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItem({
    required String field,
    required String time,
    required String duration,
    required String water,
    required String type,
    required String reason,
    required String status,
    bool actions = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('$field - $time'), Chip(label: Text(status))],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Duration: $duration'),
                Text('Water: $water'),
                Text('Type: $type'),
                Text('Reason: $reason'),
              ],
            ),
            if (actions)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(onPressed: () {}, child: const Text('Start Now')),
                  const SizedBox(width: 8),
                  OutlinedButton(onPressed: () {}, child: const Text('Modify')),
                  const SizedBox(width: 8),
                  TextButton(onPressed: () {}, child: const Text('Cancel')),
                ],
              )
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyControls() {
    return Card(
      color: Colors.red.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Emergency Controls',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildEmergencyButton('Emergency Stop', Icons.power_settings_new),
                _buildEmergencyButton('Stop All Irrigation', Icons.water_drop),
                _buildEmergencyButton('Manual Override', Icons.settings),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyButton(String label, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade100),
    );
  }
}

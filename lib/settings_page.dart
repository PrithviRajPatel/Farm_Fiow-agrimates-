import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
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
            children: [
              _buildSystemSettingsCard(),
              const SizedBox(height: 16),
              _buildLanguageLocationCard(),
              const SizedBox(height: 16),
              _buildNotificationsCard(),
              const SizedBox(height: 16),
              _buildSystemConfigurationCard(),
              const SizedBox(height: 16),
              _buildSystemStatusCard(),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Save Settings'),
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSystemSettingsCard() {
    return Card(
      color: Colors.blueGrey.shade800,
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.settings, color: Colors.white, size: 32),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'System Settings',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Configure your Farm Flow system preferences',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageLocationCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Language & Location', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('Interface Language'),
            DropdownButtonFormField<String>(
              value: 'us English',
              items: ['us English'].map((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
              onChanged: (_) {},
            ),
            const SizedBox(height: 16),
            const Text('Farm Location'),
            TextFormField(
              initialValue: 'Banauli, Manaur, Mirzapur, UP, India',
              decoration: const InputDecoration(prefixIcon: Icon(Icons.location_on)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Notifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildNotificationItem('Enable Notifications', 'Receive system alerts and updates', true),
            _buildNotificationItem('Weather Alerts', 'ISRO weather warnings and forecasts', true),
            _buildNotificationItem('Irrigation Alerts', 'Irrigation schedule and status updates', true),
            _buildNotificationItem('Fertilizer Reminders', 'NPK deficiency and application reminders', true),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(String title, String subtitle, bool value) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: (bool val) {},
    );
  }

  Widget _buildSystemConfigurationCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('System Configuration', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildNotificationItem('Auto Irrigation', 'Enable AI-powered automatic irrigation', true),
            const SizedBox(height: 16),
            const Text('Sensor Reading Frequency (minutes)'),
            DropdownButtonFormField<String>(
              value: 'Every 30 minutes',
              items: ['Every 30 minutes'].map((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
              onChanged: (_) {},
            ),
            const SizedBox(height: 16),
            const Text('Weather Sync Interval (minutes)'),
            DropdownButtonFormField<String>(
              value: 'Every 10 minutes',
              items: ['Every 10 minutes'].map((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
              onChanged: (_) {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemStatusCard() {
    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('System Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildStatusItem('IoT Connection', 'Connected', Colors.green),
            _buildStatusItem('AI Processing', 'Active', Colors.green),
            _buildStatusItem('Weather Sync', 'Online', Colors.green),
            _buildStatusItem('Solar Power', '87% Charged', Colors.orange),
            _buildStatusItem('Sensor Network', '8/8 Online', Colors.green),
            _buildStatusItem('Last Backup', '2 hours ago', Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(String title, String status, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(title), Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold))],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final DatabaseReference _settingsRef = FirebaseDatabase.instance.ref('settings');

  late Map<String, dynamic> _settings;

  @override
  void initState() {
    super.initState();
    _settings = {};
  }

  void _updateSetting(String key, dynamic value) {
    setState(() {
      _settings[key] = value;
    });
  }

  Future<void> _saveSettings() async {
    await _settingsRef.update(_settings);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings saved successfully!')),
      );
    }
  }

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
      body: StreamBuilder(
          stream: _settingsRef.onValue,
          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (snapshot.hasData && !snapshot.hasError && snapshot.data!.snapshot.value != null) {
              final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
              _settings = Map<String, dynamic>.from(data); // Initialize settings from Firebase

              return SingleChildScrollView(
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
                        onPressed: _saveSettings,
                        child: const Text('Save Settings'),
                        style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                      )
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
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
              value: _settings['language'] ?? 'us English',
              items: ['us English', 'hi Hindi', 'pa Punjabi'].map((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
              onChanged: (val) => _updateSetting('language', val),
            ),
            const SizedBox(height: 16),
            const Text('Farm Location'),
            TextFormField(
              initialValue: _settings['farm_location'] ?? '',
              onChanged: (val) => _updateSetting('farm_location', val),
              decoration: const InputDecoration(prefixIcon: Icon(Icons.location_on)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationsCard() {
    final notifications = _settings['notifications'] as Map<dynamic, dynamic>? ?? {};
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Notifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildNotificationItem('Enable Notifications', 'Receive system alerts and updates',
                notifications['enable_notifications'] ?? true, (val) => _updateSetting('notifications/enable_notifications', val)),
            _buildNotificationItem(
                'Weather Alerts', 'ISRO weather warnings and forecasts', notifications['weather_alerts'] ?? true, (val) => _updateSetting('notifications/weather_alerts', val)),
            _buildNotificationItem('Irrigation Alerts', 'Irrigation schedule and status updates',
                notifications['irrigation_alerts'] ?? true, (val) => _updateSetting('notifications/irrigation_alerts', val)),
            _buildNotificationItem('Fertilizer Reminders', 'NPK deficiency and application reminders',
                notifications['fertilizer_reminders'] ?? true, (val) => _updateSetting('notifications/fertilizer_reminders', val)),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildSystemConfigurationCard() {
    final systemConfig = _settings['system_configuration'] as Map<dynamic, dynamic>? ?? {};
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('System Configuration', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildNotificationItem('Auto Irrigation', 'Enable AI-powered automatic irrigation',
                systemConfig['auto_irrigation'] ?? true, (val) => _updateSetting('system_configuration/auto_irrigation', val)),
            const SizedBox(height: 16),
            const Text('Sensor Reading Frequency (minutes)'),
            DropdownButtonFormField<int>(
              value: systemConfig['sensor_frequency'] ?? 30,
              items: [10, 30, 60].map((int value) {
                return DropdownMenuItem<int>(value: value, child: Text('Every $value minutes'));
              }).toList(),
              onChanged: (val) => _updateSetting('system_configuration/sensor_frequency', val),
            ),
            const SizedBox(height: 16),
            const Text('Weather Sync Interval (minutes)'),
            DropdownButtonFormField<int>(
              value: systemConfig['weather_interval'] ?? 10,
              items: [5, 10, 15].map((int value) {
                return DropdownMenuItem<int>(value: value, child: Text('Every $value minutes'));
              }).toList(),
              onChanged: (val) => _updateSetting('system_configuration/weather_interval', val),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemStatusCard() {
    final systemStatus = _settings['system_status'] as Map<dynamic, dynamic>? ?? {};
    return Card(
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('System Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildStatusItem('IoT Connection', systemStatus['iot_connection'] ?? 'N/A', Colors.green),
            _buildStatusItem('AI Processing', systemStatus['ai_processing'] ?? 'N/A', Colors.green),
            _buildStatusItem('Weather Sync', systemStatus['weather_sync'] ?? 'N/A', Colors.green),
            _buildStatusItem('Solar Power', systemStatus['solar_power'] ?? 'N/A', Colors.orange),
            _buildStatusItem('Sensor Network', systemStatus['sensor_network'] ?? 'N/A', Colors.green),
            _buildStatusItem('Last Backup', systemStatus['last_backup'] ?? 'N/A', Colors.blue),
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

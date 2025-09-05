
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ControlsPage extends StatefulWidget {
  const ControlsPage({super.key});

  @override
  State<ControlsPage> createState() => _ControlsPageState();
}

class _ControlsPageState extends State<ControlsPage> {
  final DatabaseReference _controlsRef = FirebaseDatabase.instance.ref('controls');
  // TODO: Add your Gemini API key here
  final String _geminiApiKey = 'AIzaSyC-a3CqW2S9j2lLuL6ffFPtT5ayvIE1Ygs';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controls'),
      ),
      body: StreamBuilder(
        stream: _controlsRef.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasData &&
              !snapshot.hasError &&
              snapshot.data!.snapshot.value != null) {
            final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
            final systemControls = data['system_controls'] ?? {};
            final manualIrrigation = data['manual_irrigation'] ?? {};

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSystemControlsCard(systemControls),
                    const SizedBox(height: 24),
                    _buildManualIrrigationControls(manualIrrigation),
                    const SizedBox(height: 24),
                    _buildAiScheduleCard(),
                    const SizedBox(height: 24),
                    _buildEmergencyControls(),
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

  Widget _buildSystemControlsCard(Map<dynamic, dynamic> systemControls) {
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
              'Manage your smart farming systems',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 3,
              children: [
                _buildControlToggle(
                  'Irrigation System',
                  systemControls['irrigation_system'] ?? false,
                  (val) => _controlsRef.child('system_controls/irrigation_system').set(val),
                ),
                _buildControlToggle(
                  'AI Automation',
                  systemControls['ai_automation'] ?? false,
                  (val) => _controlsRef.child('system_controls/ai_automation').set(val),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlToggle(String title, bool value, ValueChanged<bool> onChanged) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Switch(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }

  Widget _buildManualIrrigationControls(Map<dynamic, dynamic> manualIrrigation) {
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
              children: manualIrrigation.entries.map((entry) {
                final fieldName = entry.key;
                final fieldData = entry.value;
                return _buildFieldControl(fieldName, fieldData);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldControl(String fieldName, Map<dynamic, dynamic> fieldData) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(fieldName, style: const TextStyle(fontWeight: FontWeight.bold)),
            Chip(label: Text(fieldData['status'] ?? 'N/A')),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: () =>
                      _controlsRef.child('manual_irrigation/$fieldName/status').set('Active'),
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () =>
                      _controlsRef.child('manual_irrigation/$fieldName/status').set('Stopped'),
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

  Widget _buildAiScheduleCard() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'AI-Powered Irrigation Schedule',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _generateSchedule,
              icon: const Icon(Icons.refresh),
              label: const Text('Generate Schedule'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _generateSchedule() async {
    final model = GenerativeModel(model: 'gemini-pro', apiKey: _geminiApiKey);
    const prompt =
        'Generate an optimal irrigation schedule for a farm with 3 fields. Consider factors like crop type, weather forecast, and soil moisture levels. Format the output as a JSON object with field names as keys and a schedule as the value.';

    try {
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      final jsonResponse = response.text?.replaceAll('\n', '').replaceAll('  ', '') ?? '{}';
      final schedule = json.decode(jsonResponse);
      _controlsRef.child('irrigation_schedule').set(schedule);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('AI-powered schedule generated and applied!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating schedule: $e')),
      );
    }
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
                _buildEmergencyButton(
                  'Emergency Stop',
                  Icons.power_settings_new,
                  () => _controlsRef.child('emergency_stop').set(true),
                ),
                _buildEmergencyButton(
                  'Stop All Irrigation',
                  Icons.water_drop,
                  () => _controlsRef.child('stop_all_irrigation').set(true),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyButton(String label, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade100),
    );
  }
}

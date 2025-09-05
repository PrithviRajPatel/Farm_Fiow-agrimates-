
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class AIRecommendationsPage extends StatefulWidget {
  final List<String> crops;
  const AIRecommendationsPage({super.key, required this.crops});

  @override
  State<AIRecommendationsPage> createState() => _AIRecommendationsPageState();
}

class _AIRecommendationsPageState extends State<AIRecommendationsPage> {
  // TODO: Add your Gemini API key here
  static const String _apiKey = 'AIzaSyC-a3CqW2S9j2lLuL6ffFPtT5ayvIE1Ygs';

  List<Map<String, dynamic>> _recommendations = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchRecommendations();
  }

  Future<void> _fetchRecommendations() async {
    final model = GenerativeModel(model: 'gemini-pro', apiKey: _apiKey);
    final prompt =
        'Generate a list of farming recommendations for the following crops: ${widget.crops.join(', ')}. Provide a title, description, priority (High, Medium, Low), and expected benefit for each recommendation. Format the output as a JSON array.';

    try {
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      final jsonResponse = response.text?.replaceAll('\n', '').replaceAll('  ', '') ?? '[]';
      final recommendations = List<Map<String, dynamic>>.from(json.decode(jsonResponse));
      setState(() {
        _recommendations = recommendations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Recommendations'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text('Error: $_errorMessage'))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAIRecommendationsCard(),
                        const SizedBox(height: 24),
                        _buildRecommendationCards(),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildAIRecommendationsCard() {
    final urgentCount = _recommendations.where((r) => r['priority'] == 'High').length;
    final highPriorityCount = _recommendations.where((r) => r['priority'] == 'Medium').length;
    return Card(
      color: Colors.orange.shade300,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.lightbulb, color: Colors.white, size: 32),
                SizedBox(width: 12),
                Text(
                  'AI Recommendations',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Smart farming insights for your crops',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RecommendationStat(count: urgentCount.toString(), label: 'Urgent'),
                RecommendationStat(count: highPriorityCount.toString(), label: 'High Priority'),
                RecommendationStat(count: _recommendations.length.toString(), label: 'Total Active'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCards() {
    return ListView.builder(
      itemCount: _recommendations.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final recommendation = _recommendations[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: RecommendationCard(
            title: recommendation['title'],
            priority: recommendation['priority'],
            description: recommendation['description'],
            expectedBenefit: recommendation['expected_benefit'],
            onComplete: () {
              setState(() {
                _recommendations.removeAt(index);
              });
            },
            onDismiss: () {
              setState(() {
                _recommendations.removeAt(index);
              });
            },
          ),
        );
      },
    );
  }
}

class RecommendationStat extends StatelessWidget {
  final String count;
  final String label;

  const RecommendationStat({super.key, required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(count, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}

class RecommendationCard extends StatelessWidget {
  final String title;
  final String priority;
  final String description;
  final String expectedBenefit;
  final VoidCallback onComplete;
  final VoidCallback onDismiss;

  const RecommendationCard({
    super.key,
    required this.title,
    required this.priority,
    required this.description,
    required this.expectedBenefit,
    required this.onComplete,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Chip(
              label: Text(priority),
              backgroundColor: _getPriorityColor(priority),
            ),
            const SizedBox(height: 16),
            Text(description),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.green.shade50,
              child: Text(expectedBenefit),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: onComplete,
                  icon: const Icon(Icons.check),
                  label: const Text('Mark Complete'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
                const Spacer(),
                IconButton(onPressed: onDismiss, icon: const Icon(Icons.close)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red.shade200;
      case 'medium':
        return Colors.orange.shade200;
      case 'low':
        return Colors.blue.shade200;
      default:
        return Colors.grey;
    }
  }
}

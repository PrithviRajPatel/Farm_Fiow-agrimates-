import 'package:flutter/material.dart';

class AIRecommendationsPage extends StatelessWidget {
  const AIRecommendationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Recommendations', style: TextStyle(fontWeight: FontWeight.bold)),
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
              _buildAIRecommendationsCard(),
              const SizedBox(height: 24),
              _buildFilterChips(),
              const SizedBox(height: 24),
              _buildRecommendationCards(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAIRecommendationsCard() {
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
              'Smart farming insights powered by artificial intelligence',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const RecommendationStat(count: '0', label: 'Urgent'),
                const RecommendationStat(count: '1', label: 'High Priority'),
                const RecommendationStat(count: '4', label: 'Total Active'),
                Row(
                  children: [
                    const Chip(label: Text('us EN')),
                    const SizedBox(width: 8),
                    Container(width: 40, height: 40, color: Colors.white.withOpacity(0.3)),
                    const SizedBox(width: 8),
                    Container(width: 40, height: 40, color: Colors.white.withOpacity(0.3)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: const [
          FilterChip(label: Text('All (4)'), onSelected: print),
          SizedBox(width: 8),
          FilterChip(label: Text('Irrigation (1)'), onSelected: print),
          SizedBox(width: 8),
          FilterChip(label: Text('Fertilizer (1)'), onSelected: print),
          SizedBox(width: 8),
          FilterChip(label: Text('Pest Alerts (1)'), onSelected: print),
          SizedBox(width: 8),
          FilterChip(label: Text('Crop (1)'), onSelected: print),
        ],
      ),
    );
  }

  Widget _buildRecommendationCards() {
    return Column(
      children: const [
        RecommendationCard(
          title: 'NPK Deficiency Detected in Field B',
          priority: 'High',
          actionRequired: true,
          description:
              'Low nitrogen levels detected in Field B. Soil analysis shows N-P-K ratio of 45-65-70. Recommend applying 25kg Urea per acre within next 3 days for optimal crop growth.',
          expectedBenefit: 'Expected Benefit: 15-20% increase in yield',
        ),
        SizedBox(height: 16),
        RecommendationCard(
          title: 'Ideal Planting Window for Winter Wheat',
          priority: 'Low',
          description:
              'Weather analysis indicates optimal conditions for winter wheat planting in the next 7-10 days. Soil temperature (28°C) and moisture levels are ideal. Consider preparing field for plantation.',
          expectedBenefit: 'Expected Benefit: Optimal germination rate of 95%+',
        ),
        SizedBox(height: 16),
        RecommendationCard(
          title: 'Optimal Irrigation Schedule Updated',
          priority: 'Medium',
          description:
              'Based on current soil moisture (42%) and upcoming weather forecast, AI recommends irrigation tomorrow at 5:30 AM for 35 minutes. This will optimize water usage while maintaining ideal crop conditions.',
          expectedBenefit: 'Expected Benefit: Water savings of 120L per cycle',
        ),
        SizedBox(height: 16),
        RecommendationCard(
          title: 'High Humidity Pest Risk Alert',
          priority: 'Medium',
          actionRequired: true,
          description:
              'Current humidity levels (72%) combined with temperature (29°C) create favorable conditions for aphid and thrips infestation. Monitor crops closely for next 48 hours and consider preventive neem oil spray.',
          expectedBenefit: 'Expected Benefit: Prevent 10-30% crop damage',
        ),
      ],
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
  final bool actionRequired;
  final String description;
  final String expectedBenefit;

  const RecommendationCard({
    super.key,
    required this.title,
    required this.priority,
    this.actionRequired = false,
    required this.description,
    required this.expectedBenefit,
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
            Row(
              children: [
                Chip(
                  label: Text(priority),
                  backgroundColor: _getPriorityColor(priority),
                ),
                if (actionRequired)
                  const Chip(
                    label: Text('Action Required'),
                    backgroundColor: Colors.red,
                    labelStyle: TextStyle(color: Colors.white),
                  ),
              ],
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
                  onPressed: () {},
                  icon: const Icon(Icons.check),
                  label: const Text('Mark Complete'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
                const Spacer(),
                IconButton(onPressed: () {}, icon: const Icon(Icons.close)),
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

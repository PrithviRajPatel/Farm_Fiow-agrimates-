import 'dart:math';
import 'package:flutter/material.dart';

class NpkPage extends StatefulWidget {
  NpkPage({Key? key}) : super(key: key);

  @override
  State<NpkPage> createState() => _NpkPageState();
}

class _NpkPageState extends State<NpkPage> {
  int nitrogen = 0;
  int phosphorus = 0;
  int potassium = 0;
  String recommendation = "";

  @override
  void initState() {
    super.initState();
    _generateRandomValues();
  }

  void _generateRandomValues() {
    final random = Random();
    setState(() {
      nitrogen = 20 + random.nextInt(60);   // 20–80
      phosphorus = 10 + random.nextInt(40); // 10–50
      potassium = 30 + random.nextInt(70);  // 30–100
      recommendation = _generateRecommendation();
    });
  }

  String _generateRecommendation() {
    if (nitrogen < 30) {
      return "⚠️ Low Nitrogen: Add Urea or compost.";
    } else if (phosphorus < 20) {
      return "⚠️ Low Phosphorus: Use DAP or rock phosphate.";
    } else if (potassium < 40) {
      return "⚠️ Low Potassium: Apply MOP or potash fertilizers.";
    } else {
      return "✅ Soil nutrients are balanced. Suitable for wheat, rice, and maize.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NPK Detection"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _generateRandomValues, // Refresh values
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ✅ Dashboard Grid Style
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1,
                children: [
                  _buildNpkCard("Nitrogen (N)", nitrogen, Colors.blue),
                  _buildNpkCard("Phosphorus (P)", phosphorus, Colors.orange),
                  _buildNpkCard("Potassium (K)", potassium, Colors.purple),
                  _buildRecommendationCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNpkCard(String title, int value, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.science, color: color, size: 40),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "$value",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard() {
    return Card(
      color: Colors.green.shade100,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            recommendation,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

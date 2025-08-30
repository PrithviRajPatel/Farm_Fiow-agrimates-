import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeaturesPage extends StatelessWidget {
  const FeaturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final features = [
      "🌦 Weather of the selected place",
      "🌱 Soil condition check",
      "📊 Real-time mandi price",
      "🌾 Crop growth guidance",
      "💧 Water usage suggestions",
      "🐛 Pest & disease alerts",
      "📘 Knowledge resources"
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Features"),
        leading: IconButton(
          icon: const Icon(Icons.logout),
          tooltip: "Logout",
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacementNamed(context, "/login");
          },
        ),
      ),
      body: Column(
        children: [
          if (user != null) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Welcome, ${user.displayName ?? "Farmer"} 👩‍🌾",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: features.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.check_circle, color: Colors.green),
                    title: Text(features[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        tooltip: "Go to Crops",
        onPressed: () {
          Navigator.pushNamed(context, "/crops");
        },
        child: const Icon(Icons.agriculture),
      ),
    );
  }
}

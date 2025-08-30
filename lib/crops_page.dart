import 'package:flutter/material.dart';

class CropsPage extends StatelessWidget {
  const CropsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // List of crop images from assets/images/
    final List<Map<String, String>> crops = [
      {"name": "Rice", "image": "assets/images/rice.png"},
      {"name": "Wheat", "image": "assets/images/wheat.png"},
      {"name": "Corn", "image": "assets/images/corn.png"},
      {"name": "Sugarcane", "image": "assets/images/sugarcane.png"},
      {"name": "Cotton", "image": "assets/images/cotton.png"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Crops"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: crops.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // two crops per row
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 3 / 4,
          ),
          itemBuilder: (context, index) {
            final crop = crops[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        crop["image"]!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    crop["name"]!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

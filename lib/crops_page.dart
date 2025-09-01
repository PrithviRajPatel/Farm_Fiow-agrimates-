import 'package:flutter/material.dart';

class CropsPage extends StatefulWidget {
  const CropsPage({super.key});

  @override
  State<CropsPage> createState() => _CropsPageState();
}

class _CropsPageState extends State<CropsPage> {
  // List of crop images from assets/images/
  final List<Map<String, String>> crops = [
    {"name": "Rice", "image": "assets/images/rice.png"},
    {"name": "Wheat", "image": "assets/images/wheat.png"},
    {"name": "Corn", "image": "assets/images/corn.png"},
    {"name": "Sugarcane", "image": "assets/images/sugarcane.png"},
    {"name": "Cotton", "image": "assets/images/cotton.png"},
  ];

  // Track selected crops
  final Set<String> selectedCrops = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Selected: ${selectedCrops.length} crops"),
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
            final isSelected = selectedCrops.contains(crop["name"]);

            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedCrops.remove(crop["name"]);
                  } else {
                    selectedCrops.add(crop["name"]!);
                  }
                });
              },
              child: Card(
                elevation: isSelected ? 8 : 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected ? Colors.green : Colors.grey.shade300,
                    width: 2,
                  ),
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.green : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedCrops.isNotEmpty ? Colors.green : Colors.grey,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: selectedCrops.isEmpty
              ? null
              : () {
            // ✅ Navigate to next page (replace /summary with your route)
            Navigator.pushNamed(context, "/summary", arguments: selectedCrops.toList());
          },
          child: Text(
            selectedCrops.isEmpty
                ? "Select at least 1 crop"
                : "Proceed (${selectedCrops.length}) →",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

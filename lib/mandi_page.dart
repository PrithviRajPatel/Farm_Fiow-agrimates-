import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MandiPage extends StatefulWidget {
  final String? crop;

  const MandiPage({super.key, this.crop});

  @override
  State<MandiPage> createState() => _MandiPageState();
}

class _MandiPageState extends State<MandiPage> {
  bool isLoading = false;
  List<dynamic> mandiPrices = [];
  String? errorMessage;
  String? selectedCrop;

  List<String> availableCrops = []; // ✅ Will load dynamically from API

  @override
  void initState() {
    super.initState();
    selectedCrop = widget.crop; // ✅ Set from dashboard if given
    fetchCropsAndPrices();
  }

  Future<void> fetchCropsAndPrices() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final response = await http.get(Uri.parse(
          "https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070"
              "?api-key=YOUR_API_KEY&format=json&limit=100"));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> records = data["records"] ?? [];

        // ✅ Extract unique crops dynamically
        final cropsSet = records
            .map((item) => (item["commodity"] ?? "").toString())
            .where((c) => c.isNotEmpty)
            .toSet()
            .toList()
          ..sort();

        setState(() {
          availableCrops = cropsSet.cast<String>();

          // If no crop selected yet, pick the first one
          if (selectedCrop == null && availableCrops.isNotEmpty) {
            selectedCrop = availableCrops.first;
          }

          // Filter records for selected crop
          mandiPrices = records
              .where((item) =>
              (item["commodity"] ?? "")
                  .toString()
                  .toLowerCase()
                  .contains(selectedCrop?.toLowerCase() ?? ""))
              .toList();

          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "⚠️ Couldn’t fetch mandi prices";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "⚠️ Error fetching mandi prices";
        isLoading = false;
      });
    }
  }

  String getFarmerTip() {
    if (selectedCrop != null && selectedCrop!.isNotEmpty) {
      return "💡 For $selectedCrop, check mandi prices nearby to sell at the best rate.";
    }
    return "💡 Compare mandi prices before selling to maximize profit.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("📊 Mandi Prices"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchCropsAndPrices,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🌾 Crop Selector Dropdown (dynamic)
            if (availableCrops.isNotEmpty)
              DropdownButtonFormField<String>(
                value: selectedCrop,
                hint: const Text("Select Crop"),
                items: availableCrops
                    .map((crop) =>
                    DropdownMenuItem(value: crop, child: Text(crop)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCrop = value;
                  });
                  fetchCropsAndPrices();
                },
                decoration: InputDecoration(
                  labelText: "Choose Crop",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            const SizedBox(height: 20),

            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage != null
                  ? Center(child: Text(errorMessage!))
                  : mandiPrices.isEmpty
                  ? const Center(
                  child: Text("No mandi prices found for this crop."))
                  : ListView.builder(
                itemCount: mandiPrices.length,
                itemBuilder: (context, index) {
                  final item = mandiPrices[index];
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.symmetric(
                        vertical: 8, horizontal: 4),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${item['commodity'] ?? 'Unknown Crop'}",
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text("State: ${item['state'] ?? '-'}"),
                          Text(
                              "District: ${item['district'] ?? '-'}"),
                          Text("Market: ${item['market'] ?? '-'}"),
                          Text(
                              "Price: ₹${item['modal_price'] ?? '-'}"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // 👨‍🌾 Farmer Tip
            Card(
              color: Colors.green[100],
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  getFarmerTip(),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

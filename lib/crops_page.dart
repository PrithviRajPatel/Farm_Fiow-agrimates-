import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CropSelectionPage extends StatefulWidget {
  const CropSelectionPage({super.key});

  @override
  State<CropSelectionPage> createState() => _CropSelectionPageState();
}

class _CropSelectionPageState extends State<CropSelectionPage> {
  String? selectedCrop;
  bool _isSaving = false;

  final crops = [
    {"name": "Wheat", "image": "assets/Crops/wheat.png"},
    {"name": "Rice", "image": "assets/Crops/rice.png"},
    {"name": "Corn", "image": "assets/Crops/corn.png"},
    {"name": "Mustard", "image": "assets/Crops/mustard.png"},
    {"name": "Gram", "image": "assets/Crops/gram.png"},
    {"name": "Pea", "image": "assets/Crops/pea.png"},
    {"name": "Oats", "image": "assets/Crops/oats.png"},
    {"name": "Barley", "image": "assets/Crops/barley.png"},
    {"name": "Pearl Millet", "image": "assets/Crops/pearl_millet.png"},
    {"name": "Rye", "image": "assets/Crops/rye.png"},
  ];

  @override
  void initState() {
    super.initState();
    _loadSavedCrop();
  }

  /// Load previously saved crop
  Future<void> _loadSavedCrop() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc =
    await FirebaseFirestore.instance.collection("farmers").doc(uid).get();
    if (doc.exists && doc.data()?["selectedCrop"] != null) {
      setState(() {
        selectedCrop = doc["selectedCrop"];
      });
    }
  }

  /// Save crop to Firestore
  Future<void> saveCropToFirestore(String crop) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection("farmers")
        .doc(uid)
        .set({"selectedCrop": crop}, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade50,
      appBar: AppBar(
        title: const Text("🌾 Select Your Crop"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          const Text(
            "Choose one crop you are growing",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "You can skip for now and set later",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 20),

          // ✅ GridView with crops
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 18,
                crossAxisSpacing: 18,
                childAspectRatio: 0.85,
              ),
              itemCount: crops.length,
              itemBuilder: (context, index) {
                final crop = crops[index];
                final isSelected = selectedCrop == crop["name"];

                return GestureDetector(
                  onTap: _isSaving
                      ? null
                      : () {
                    setState(() {
                      selectedCrop = crop["name"];
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                            isSelected ? Colors.green : Colors.transparent,
                            width: 4,
                          ),
                          boxShadow: isSelected
                              ? [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.4),
                              blurRadius: 8,
                              spreadRadius: 2,
                            )
                          ]
                              : [],
                        ),
                        child: CircleAvatar(
                          radius: 38,
                          backgroundImage: AssetImage(crop["image"]!),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        crop["name"]!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.green.shade800
                              : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // ✅ Confirm + Skip buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      selectedCrop == null ? Colors.grey : Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    onPressed: selectedCrop == null || _isSaving
                        ? null
                        : () async {
                      setState(() {
                        _isSaving = true;
                      });

                      bool saved = false;
                      int retries = 0;

                      while (!saved && retries < 3) {
                        try {
                          await saveCropToFirestore(selectedCrop!);

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    "✅ ${selectedCrop!} saved successfully!"),
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                            Navigator.pushReplacementNamed(
                                context, "/home");
                          }
                          saved = true;
                        } catch (e) {
                          retries++;
                          if (retries >= 3 && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "❌ Failed to save crop after multiple attempts."),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 3),
                              ),
                            );
                          } else {
                            await Future.delayed(
                                const Duration(seconds: 2));
                          }
                        }
                      }

                      if (mounted) {
                        setState(() {
                          _isSaving = false;
                        });
                      }
                    },
                    child: _isSaving
                        ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                        : const Text(
                      "Confirm",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: _isSaving
                      ? null
                      : () {
                    Navigator.pushReplacementNamed(context, "/home");
                  },
                  child: const Text(
                    "Skip for now",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

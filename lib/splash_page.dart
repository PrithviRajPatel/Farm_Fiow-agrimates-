import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard.dart';
import 'crops_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkCropSelection();
  }

  Future<void> _checkCropSelection() async {
    final prefs = await SharedPreferences.getInstance();
    final seenFeatures = prefs.getBool("seenFeatures") ?? false;
    final savedCrop = prefs.getString("selectedCrop");

    await Future.delayed(const Duration(seconds: 1)); // small splash delay

    if (!mounted) return;

    if (seenFeatures && savedCrop != null && savedCrop.isNotEmpty) {
      // ✅ User already selected crop → Go to dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardPage(crop: savedCrop),
        ),
      );
    } else {
      // ✅ First time → Show crop selection
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CropSelectionPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.agriculture, color: Colors.white, size: 80),
            SizedBox(height: 20),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}

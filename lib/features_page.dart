import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'welcome_page.dart'; // ✅ Import WelcomePage

class FeaturesPage extends StatefulWidget {
  const FeaturesPage({super.key});

  @override
  State<FeaturesPage> createState() => _FeaturesPageState();
}

class _FeaturesPageState extends State<FeaturesPage>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  late AnimationController _dotPulseController;

  final features = [
    {"title": "🌦 Weather Updates", "desc": "Get real-time weather of your village"},
    {"title": "🌱 Soil Check", "desc": "Know your soil condition before farming"},
    {"title": "📊 Mandi Prices", "desc": "Stay updated with real-time crop prices"},
    {"title": "🌾 Crop Guidance", "desc": "Get tips for better crop growth"},
    {"title": "💧 Water Usage", "desc": "Save water with smart irrigation advice"},
    {"title": "🐛 Pest Alerts", "desc": "Protect your farm from diseases"},
    {"title": "📘 Knowledge Hub", "desc": "Learn modern techniques & practices"},
  ];

  final backgroundImages = [
    "assets/background/weather.png",
    "assets/background/Soil.png",
    "assets/background/Market.png",
    "assets/background/Crop.png",
    "assets/background/Water.png",
    "assets/background/Pest.png",
    "assets/background/Knowledge.png",
  ];

  @override
  void initState() {
    super.initState();
    _dotPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _startAutoSwipe();
  }

  void _startAutoSwipe() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < features.length - 1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      } else {
        _goToNextPageOrDashboard();
      }
    });
  }

  Future<void> _goToNextPageOrDashboard() async {
    _timer?.cancel();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("seenFeatures", true);

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.uid)
          .get();

      final crop = doc.data()?["selectedCrops"];

      if (crop != null) {
        await prefs.setString("selectedCrop", crop.toString());
        if (mounted) {
          Navigator.pushReplacementNamed(context, "/dashboard",
              arguments: {"crop": crop});
        }
        return;
      }
    }

    if (mounted) {
      Navigator.pushReplacementNamed(context, "/crops");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _dotPulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green, size: 28),
          onPressed: () {
            // ✅ Always go back to WelcomePage
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const WelcomePage()),
            );
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // ✅ PageView for manual + auto swipe
          PageView.builder(
            controller: _pageController,
            itemCount: features.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    backgroundImages[index],
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.6),
                          Colors.transparent
                        ],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (user != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text(
                            "Namaste, ${user.displayName ?? "Farmer"}",
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      Text(
                        features[index]["title"]!,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 8,
                              color: Colors.black54,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          features[index]["desc"]!,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 100),
                    ],
                  ),
                ],
              );
            },
          ),

          // ✅ Dots Indicator
          Positioned(
            bottom: 70,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(features.length, (index) {
                bool isActive = _currentPage == index;
                return AnimatedBuilder(
                  animation: _dotPulseController,
                  builder: (context, child) {
                    double scale = isActive
                        ? 1.0 + (_dotPulseController.value * 0.3)
                        : 1.0;
                    return Transform.scale(
                      scale: scale,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 10,
                        width: isActive ? 24 : 10,
                        decoration: BoxDecoration(
                          color: isActive ? Colors.green : Colors.white54,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: isActive
                              ? [
                            BoxShadow(
                              color: Colors.greenAccent.withOpacity(0.7),
                              blurRadius: 8,
                              spreadRadius: 2,
                            )
                          ]
                              : [],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ),

          // ✅ Skip button
          if (_currentPage < features.length - 1)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 8),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black45,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: _goToNextPageOrDashboard,
                  child: const Text(
                    "Skip",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

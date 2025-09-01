import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FeaturesPage extends StatefulWidget {
  const FeaturesPage({super.key});

  @override
  State<FeaturesPage> createState() => _FeaturesPageState();
}

class _FeaturesPageState extends State<FeaturesPage>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;

  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  late AnimationController _dotPulseController;
  late AnimationController _arrowController;
  late Animation<double> _arrowAnimation;

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
    "assets/background/Knowleadge.png",
  ];

  @override
  void initState() {
    super.initState();
    _startAutoPageSwitch();

    // Bounce animation for button
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 0, end: -12).chain(
      CurveTween(curve: Curves.elasticOut),
    ).animate(_bounceController);

    // Dots animation
    _dotPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    // Swipe-up arrow animation
    _arrowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _arrowAnimation =
        Tween<double>(begin: 0, end: -15).animate(CurvedAnimation(
          parent: _arrowController,
          curve: Curves.easeInOut,
        ));
  }

  void _startAutoPageSwitch() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage < features.length - 1) {
        _goToNextPage();
      } else {
        _goToCropsPage();
      }
    });
  }

  void _goToNextPage() {
    if (_currentPage < features.length - 1) {
      setState(() {
        _currentPage++;
      });
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
      );
      _bounceController.forward(from: 0);
    } else {
      _goToCropsPage();
    }
  }

  void _goToCropsPage() {
    _timer?.cancel();
    Navigator.pushReplacementNamed(context, "/crops");
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _bounceController.dispose();
    _dotPulseController.dispose();
    _arrowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Stack(
        children: [
          // Background with parallax
          PageView.builder(
            controller: _pageController,
            itemCount: features.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
              _bounceController.forward(from: 0);
            },
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 0.0;
                  if (_pageController.position.haveDimensions) {
                    value = index.toDouble() - (_pageController.page ?? 0);
                    value = (value * 0.3).clamp(-1, 1);
                  }
                  return Transform.translate(
                    offset: Offset(value * 50, 0),
                    child: child,
                  );
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(backgroundImages[index], fit: BoxFit.cover),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Welcome text
          if (user != null)
            Positioned(
              top: 60,
              left: 20,
              child: Text(
                "Namaste, ${user.displayName ?? "Farmer"}",
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          // Title + desc
          Positioned(
            bottom: 160,
            left: 20,
            right: 20,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: Column(
                key: ValueKey(_currentPage),
                children: [
                  Text(
                    features[_currentPage]["title"]!,
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
                  Text(
                    features[_currentPage]["desc"]!,
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // Pulsing dots
          Positioned(
            bottom: 100,
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

          // Glowing Next button
          Positioned(
            bottom: 45,
            left: 50,
            right: 50,
            child: AnimatedBuilder(
              animation: _bounceAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _bounceAnimation.value),
                  child: child,
                );
              },
              child: GestureDetector(
                onTap: _goToNextPage,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.green, Colors.lightGreen],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.greenAccent.withOpacity(0.6),
                        blurRadius: 12,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _currentPage < features.length - 1
                        ? "Next ➡️"
                        : "Go to Crops 🚜",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Swipe-up arrow
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _arrowAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _arrowAnimation.value),
                  child: child,
                );
              },
              child: const Icon(
                Icons.keyboard_arrow_up_rounded,
                size: 32,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

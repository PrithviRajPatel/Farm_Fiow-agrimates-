import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _fadeAnimation =
        CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut);

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));

    _fadeController.forward();

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );

    _fadeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _bounceController.forward();
      }
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  Future<String> _getFarmerName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return "Farmer";

    final docRef =
    FirebaseFirestore.instance.collection("farmers").doc(user.uid);
    final snapshot = await docRef.get();

    if (snapshot.exists) {
      final data = snapshot.data();
      if (data != null &&
          data["name"] != null &&
          data["name"].toString().isNotEmpty) {
        return data["name"];
      }
    }

    // If no Firestore record, create one
    String fallbackName =
        user.displayName ?? user.email?.split('@')[0] ?? "Farmer";

    await docRef.set({
      "name": fallbackName,
      "createdAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return fallbackName;
  }

  Future<void> _handleGetStarted(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (context.mounted) {
        Navigator.pushReplacementNamed(context, "/login");
      }
      return;
    }

    final farmerRef =
    FirebaseFirestore.instance.collection("farmers").doc(user.uid);

    final doc = await farmerRef.get();
    if (!doc.exists) {
      await farmerRef.set({
        "uid": user.uid,
        "email": user.email,
        "name": user.displayName ?? user.email?.split('@')[0] ?? "Farmer",
        "createdAt": FieldValue.serverTimestamp(),
        "selectedCrop": null,
      });
    }

    if (context.mounted) {
      Navigator.pushNamed(context, "/cropSelection");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/farm_bg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Overlay
          Container(
            color: Colors.white.withOpacity(0.65),
          ),

          Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12, top: 4, bottom: 4),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [Colors.green, Colors.lightGreen],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.greenAccent.withOpacity(0.4),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.logout, color: Colors.white),
                        tooltip: "Logout",
                        onPressed: () => _logout(context),
                      ),
                    ),
                  ),
                ],
              ),

              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: FutureBuilder<String>(
                      future: _getFarmerName(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        final name = snapshot.data ?? "Farmer";

                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 70,
                                  backgroundColor: Colors.green.shade100,
                                  backgroundImage: const AssetImage(
                                      "assets/images/logo.png"),
                                ),
                                const SizedBox(height: 40),

                                Text(
                                  "Namaste, $name",
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 60),

                                // ✅ Get Started Button
                                ScaleTransition(
                                  scale: _bounceAnimation,
                                  child: InkWell(
                                    onTap: () => _handleGetStarted(context),
                                    borderRadius: BorderRadius.circular(30),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 60, vertical: 16),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF2E7D32),
                                            Color(0xFF66BB6A)
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.green.withOpacity(0.4),
                                            blurRadius: 12,
                                            offset: const Offset(0, 6),
                                          ),
                                        ],
                                      ),
                                      child: const Text(
                                        "Get Started →",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

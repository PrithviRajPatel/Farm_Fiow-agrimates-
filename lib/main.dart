import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'login_page.dart';
import 'features_page.dart';
import 'crops_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("✅ Firebase initialized successfully");
  } catch (e) {
    print("❌ Firebase init error: $e");
  }

  runApp(const FarmFlowApp());
}

class FarmFlowApp extends StatelessWidget {
  const FarmFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Farm Flow',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: "/login",
      routes: {
        "/login": (context) => LoginPage(),
        "/features": (context) => FeaturesPage(),
        "/crops": (context) => CropsPage(),
      },
    );
  }
}

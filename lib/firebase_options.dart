// lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Holds the correct Firebase configuration for each supported platform.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
    // You can add iOS or macOS here later if needed
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for this platform.',
        );
    }
  }

  /// ✅ Web Firebase options
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyBhLbddsgffoIo0B5qXY3OWiUj-X1L2BPw",
    appId: "1:888228300205:web:723a90808db9ef25228d24",
    messagingSenderId: "888228300205",
    projectId: "farmflow-cb2d8",
    authDomain: "farmflow-cb2d8.firebaseapp.com",
    storageBucket: "farmflow-cb2d8.appspot.com",
    measurementId: "G-F8CETL64DE",
  );

  /// ✅ Android Firebase options
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyBJSXxc85oLd_YY9axLqOgbDyL12Iu8ECw",
    appId: "1:888228300205:android:d3905ae3650689c2228d24",
    messagingSenderId: "888228300205",
    projectId: "farmflow-cb2d8",
    storageBucket: "farmflow-cb2d8.appspot.com",
  );
}

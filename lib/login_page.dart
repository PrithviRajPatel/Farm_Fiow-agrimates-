import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _loading = false;

  Future<UserCredential?> signInWithGoogle() async {
    try {
      setState(() => _loading = true);

      // Trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null; // cancelled login

      // Obtain auth details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with Firebase
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: $e")),
      );
      return null;
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : ElevatedButton.icon(
                onPressed: () async {
                  final user = await signInWithGoogle();
                  if (user != null) {
                    Navigator.pushReplacementNamed(context, "/features");
                  }
                },
                icon: const Icon(Icons.login),
                label: const Text("Sign in with Google"),
              ),
      ),
    );
  }
}

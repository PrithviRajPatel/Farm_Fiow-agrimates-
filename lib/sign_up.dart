import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController villageController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _loading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    final name = nameController.text.trim();
    final village = villageController.text.trim();
    final location = locationController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      setState(() => _loading = true);

      // ✅ Create user in Firebase Auth
      UserCredential userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // ✅ Save farmer details in Firestore
      await FirebaseFirestore.instance
          .collection("farmers")
          .doc(userCredential.user!.uid)
          .set({
        "name": name,
        "village": village,
        "location": location,
        "email": email,
        "createdAt": DateTime.now(),
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Account created successfully!")),
        );
        Navigator.pushReplacementNamed(context, "/welcome");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        _showError("Password is too weak.");
      } else if (e.code == 'email-already-in-use') {
        _showError("Email is already registered.");
      } else {
        _showError("Error: ${e.message}");
      }
    } catch (e) {
      _showError("Sign up failed: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              const Icon(Icons.agriculture, size: 80, color: Colors.green),
              const SizedBox(height: 16),
              const Text(
                "Farmer Registration",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              // ✅ Name
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value!.isEmpty ? "Enter your full name" : null,
              ),
              const SizedBox(height: 20),

              // ✅ Village
              TextFormField(
                controller: villageController,
                decoration: const InputDecoration(
                  labelText: "Village",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value!.isEmpty ? "Enter your village" : null,
              ),
              const SizedBox(height: 20),

              // ✅ Location
              TextFormField(
                controller: locationController,
                decoration: const InputDecoration(
                  labelText: "Location",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value!.isEmpty ? "Enter your location" : null,
              ),
              const SizedBox(height: 20),

              // ✅ Email
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                !_isValidEmail(value!) ? "Enter a valid email" : null,
              ),
              const SizedBox(height: 20),

              // ✅ Password
              TextFormField(
                controller: passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value!.length < 6) {
                    return "Password must be at least 6 characters";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // ✅ Confirm Password
              TextFormField(
                controller: confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                validator: (value) =>
                value != passwordController.text ? "Passwords do not match" : null,
              ),
              const SizedBox(height: 30),

              // ✅ Sign Up Button
              _loading
                  ? const CircularProgressIndicator(color: Colors.green)
                  : ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 80, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _signUp,
                child: const Text("Sign Up"),
              ),
              const SizedBox(height: 20),

              // ✅ Already have an account → Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, "/login");
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

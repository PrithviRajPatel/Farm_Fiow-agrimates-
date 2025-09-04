import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneLoginPage extends StatefulWidget {
  const PhoneLoginPage({super.key});

  @override
  State<PhoneLoginPage> createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  String? verificationId;
  bool otpSent = false;
  bool _loading = false;

  // ✅ Step 1: Send OTP
  Future<void> _sendOTP() async {
    setState(() => _loading = true);

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneController.text.trim(),
      timeout: const Duration(seconds: 60),

      // Called when verification is completed automatically (Android only)
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        if (mounted) Navigator.pushReplacementNamed(context, "/welcome");
      },

      // Called if verification fails
      verificationFailed: (FirebaseAuthException e) {
        _showMessage("Error: ${e.message}");
      },

      // Called when code is sent to the user's phone
      codeSent: (String verId, int? resendToken) {
        setState(() {
          verificationId = verId;
          otpSent = true;
        });
        _showMessage("OTP sent! Please check your phone.");
      },

      // Called if auto-retrieval times out
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
      },
    );

    setState(() => _loading = false);
  }

  // ✅ Step 2: Verify OTP
  Future<void> _verifyOTP() async {
    if (verificationId == null) {
      _showMessage("Request OTP first!");
      return;
    }

    try {
      setState(() => _loading = true);

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: otpController.text.trim(),
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      if (mounted) {
        Navigator.pushReplacementNamed(context, "/welcome");
      }
    } on FirebaseAuthException catch (e) {
      _showMessage("Invalid OTP: ${e.message}");
    } finally {
      setState(() => _loading = false);
    }
  }

  void _showMessage(String message, {bool error = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Phone Login")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!otpSent) ...[
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Enter Phone Number",
                  prefixIcon: Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loading ? null : _sendOTP,
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Send OTP"),
              ),
            ] else ...[
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Enter OTP",
                  prefixIcon: Icon(Icons.lock),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loading ? null : _verifyOTP,
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Verify OTP"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

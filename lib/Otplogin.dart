import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'features_page.dart';

class PhoneLoginPage extends StatefulWidget {
  const PhoneLoginPage({super.key});

  @override
  State<PhoneLoginPage> createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String verificationId = "";
  bool otpSent = false;
  bool isLoading = false;

  Future<void> loginWithPhone() async {
    String phone = phoneController.text.trim();

    if (!phone.startsWith("+")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Enter phone in format +91XXXXXXXXXX")),
      );
      return;
    }

    setState(() => isLoading = true);

    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        _goToFeaturesPage();
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Error: ${e.message}")),
        );
      },
      codeSent: (String verId, int? resendToken) {
        setState(() {
          verificationId = verId;
          otpSent = true;
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ OTP sent!")),
        );
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
      },
    );
  }

  Future<void> verifyOTP(String otp) async {
    setState(() => isLoading = true);
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      await _auth.signInWithCredential(credential);
      _goToFeaturesPage();
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Invalid OTP")),
      );
    }
  }

  void _goToFeaturesPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const FeaturesPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login with Phone")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                hintText: "+91XXXXXXXXXX",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: isLoading ? null : loginWithPhone,
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Send OTP"),
            ),

            if (otpSent) ...[
              const SizedBox(height: 20),
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Enter OTP",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () => verifyOTP(otpController.text.trim()),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Verify OTP"),
              ),
            ]
          ],
        ),
      ),
    );
  }
}

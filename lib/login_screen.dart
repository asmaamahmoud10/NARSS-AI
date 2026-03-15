// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  String message = "";

  void handleLogin() async {
    String phone = phoneController.text.trim();

    if (phone.isEmpty) {
      setState(() {
        message = "Please enter your phone number";
      });
      return;
    } else if (phone.length != 11 || !RegExp(r'^[0-9]+$').hasMatch(phone)) {
      setState(() {
        message = "Phone number must be exactly 11 digits";
      });
      return;
    } else if (!['0', '1', '2', '5'].contains(phone[2])) {
      setState(() {
        message = "The third digit must be 0, 1, 2, or 5";
      });
      return;
    }

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    DocumentSnapshot snapshot = await firestore
        .collection('Users')
        .doc(phone)
        .get();

    if (snapshot.exists) {
      String name = snapshot['name'];

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(phone: phone, name: name),
        ),
      );
    } else {
      setState(() {
        message = "This phone number is not registered";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/images/logo.jpeg", height: 200),

              const SizedBox(height: 30),

              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  labelStyle: const TextStyle(color: Color(0xFF2E7D32)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF2E7D32)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFF2E7D32),
                      width: 2,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: handleLogin,
                child: const Text(
                  "(OTP)تسجيل الدخول / الرمز",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                message,
                style: const TextStyle(color: Colors.red, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

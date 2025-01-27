import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../app_colors.dart';
import 'loginscreen.dart';
import '/FirebaseAuthService.dart';
import 'homescreen.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();

  void _createAccount() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both email and password.')),
      );
      return;
    }

    try {
      User? user = await _authService.createUserWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created and signed in successfully')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()), // Navigate to home screen
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'too-many-requests') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Too many requests. Please try again later.')),
        );
      } else {
        print('Account creation failed: ${e.message}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create account: ${e.message}')),
        );
      }
    } catch (e) {
      // Handle any other errors
      print('Account creation failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create account')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: beigecolor,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'images/SSLogo.png',
                height: 80,
                width: 80,
              ),
              Text(
                "SwiftSketch",
                style: TextStyle(fontSize: 32),
              )
            ],
          ),
          ConstrainedBox(
            constraints: const BoxConstraints.expand(height: 302, width: 350),
            child: Container(
              decoration: BoxDecoration(
                color: whitecolor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Container(
                    height: 40,
                    width: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: blackcolor),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextField(
                      controller: _emailController,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Email',
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 40,
                    width: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: blackcolor),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Password',
                      ),
                      obscureText: true,
                    ),
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        minimumSize: const Size(200, 40),
                        backgroundColor: dgreencolor,
                        foregroundColor: beigecolor),
                    onPressed: _createAccount,
                    child: const Text('Create Account'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      'Back to Login',
                      style: TextStyle(color: dgreencolor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

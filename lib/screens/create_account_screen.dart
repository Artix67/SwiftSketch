import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'loginscreen.dart';
import '/FirebaseAuthService.dart';
import 'homescreen.dart';

const Color dgreencolor = Color(0xFF181C14);
const Color lgreencolor = Color(0xFF697565);
const Color biegecolor = Color(0xFFCBC2B4);
const Color redcolor = Color(0xFFAB3E2B);
const Color bluecolor = Color(0xFF11487A);
const Color blackcolor = Color(0xFF181818);
const Color midgreencolor = Color(0xFF3C3D37);
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
      backgroundColor: biegecolor,
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
                        foregroundColor: biegecolor),
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
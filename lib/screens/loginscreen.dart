import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:swift_sketch/screens/draw_screen.dart';
import '/FirebaseAuthService.dart';
import 'create_account_screen.dart';
import 'homescreen.dart';

const Color dgreencolor = Color(0xFF181C14);
const Color lgreencolor = Color(0xFF697565);
const Color biegecolor = Color(0xFFCBC2B4);
const Color redcolor = Color(0xFFAB3E2B);
const Color bluecolor = Color(0xFF11487A);
const Color blackcolor = Color(0xFF181818);
const Color midgreencolor = Color(0xFF3C3D37);
const Color whitecolor = Color(0xFFEEEEEE);

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();

  void _signIn() async {
    try {
      User? user = await _authService.signInWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      // Handle login error
      print('Login failed: $e');
    }
  }

  void _resetPassword() async {
    if (_emailController.text.isNotEmpty) {
      try {
        await _authService.resetPassword(_emailController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset email sent')),
        );
      } catch (e) {
        print('Password reset failed: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send password reset email')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email')),
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
                  SizedBox(
                    height: 10,
                  ),
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
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 40,
                    width: 300,
                    decoration: BoxDecoration(
                      border: Border.all(color: blackcolor),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextField(
                      controller: _passwordController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Password',
                      ),
                      obscureText: true,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        minimumSize: const Size(200, 40),
                        backgroundColor: dgreencolor,
                        foregroundColor: biegecolor),
                    onPressed: _signIn,
                    child: const Text("Sign In"),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        minimumSize: const Size(200, 40),
                        backgroundColor: dgreencolor,
                        foregroundColor: biegecolor),
                    onPressed: () async {
                      bool proceedAsGuest = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Continue as Guest?'),
                            content: const Text(
                              'You cannot save drawings without an account. Are you sure you want to sign in as a guest?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(false); // User chose not to proceed
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(true); // User chose to proceed
                                },
                                child: const Text('Proceed'),
                              ),
                            ],
                          );
                        },
                      );

                      if (proceedAsGuest == true) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return const Drawscreen(
                                projectName: "none",
                                exportImmediately: false,
                                isGuest: true,
                              );
                            },
                          ),
                        );
                      }
                    },
                    child: const Text('Guest'),
                  ),
                  TextButton(
                    onPressed: _resetPassword,
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: dgreencolor),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return const CreateAccountScreen();
                          }),
                        );
                      },
                      child: const Text(
                        'Create Account',
                        style: TextStyle(color: dgreencolor),
                      )),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

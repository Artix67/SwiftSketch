import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../app_colors.dart';
import 'draw_screen.dart';
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
          const SnackBar(
              content: Text('Account created and signed in successfully')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const HomeScreen()), // Navigate to home screen
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'too-many-requests') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Too many requests. Please try again later.')),
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
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 382,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'images/SSLogo.png',
                  height: 90,
                  width: 90,
                ),
                const Text(
                  "SwiftSketch",
                  style: TextStyle(fontSize: 40),
                )
              ],
            ),
          ),
          IntrinsicHeight(
            child: IntrinsicWidth(
              child: Container(
                decoration: BoxDecoration(
                  color: whitecolor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Create an Account",
                              style: TextStyle(fontSize: 24)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 40,
                        width: 350,
                        decoration: BoxDecoration(
                          color: whitecolor,
                          border: Border.all(
                            color: blackcolor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: TextField(
                          controller: _emailController,
                          style:
                              const TextStyle(fontSize: 14, color: blackcolor),
                          textAlignVertical: TextAlignVertical.center,
                          obscureText: false,
                          decoration: const InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(color: placeholdercolor),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: whitecolor,
                          border: Border.all(
                            color: blackcolor,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: TextField(
                          controller: _passwordController,
                          style:
                              const TextStyle(fontSize: 14, color: blackcolor),
                          textAlignVertical: TextAlignVertical.center,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyle(color: placeholdercolor),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          ElevatedButton(
                            style: OutlinedButton.styleFrom(
                                backgroundColor: lgreycolor,
                                foregroundColor: blackcolor),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()),
                              );
                            },
                            child: const Text('Back'),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            style: OutlinedButton.styleFrom(
                                backgroundColor: lgreencolor,
                                foregroundColor: whitecolor),
                            onPressed: _createAccount,
                            child: const Text('Create'),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          TextButton(
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
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.end,
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: lgreycolor,
                                              foregroundColor: blackcolor,
                                              shape: const StadiumBorder(),
                                              padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 20,
                                                  vertical: 12),
                                            ),
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                            // Cancel
                                            child: const Text("Proceed"),
                                          ),
                                          const Spacer(),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: lgreycolor,
                                              foregroundColor: blackcolor,
                                              shape: const StadiumBorder(),
                                              padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 20,
                                                  vertical: 12),
                                            ),
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                            // Cancel
                                            child: const Text("Cancel"),
                                          ),
                                        ],
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
                            child: const Text(
                              'Continue as Guest',
                              style: TextStyle(
                                color: disablecolor,
                              ),
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

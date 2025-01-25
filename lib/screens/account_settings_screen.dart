import 'dart:async';
import 'package:flutter/material.dart';
import '/screens/settingsscreen.dart';
import '/FirebaseAuthService.dart';
import '/FirestoreService.dart';
import '/SettingsManager.dart';

const Color dgreencolor = Color(0xFF181C14);
const Color lgreencolor = Color(0xFF697565); // Default color for the button
const Color biegecolor = Color(0xFFCBC2B4);
const Color redcolor = Color(0xFFAB3E2B);
const Color bluecolor = Color(0xFF11487A);
const Color blackcolor = Color(0xFF181818);
const Color midgreencolor = Color(0xFF3C3D37);
const Color whitecolor = Color(0xFFEEEEEE);
const Color disablecolor = Color(0xFF595959); // Dark gray color for disabled state

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  _AccountSettingsScreenState createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirestoreService _firestoreService = FirestoreService();
  final SettingsManager _settingsManager = SettingsManager(); // Initialize SettingsManager
  String _currentUID = '';
  bool _isButtonDisabled = false;
  int _secondsRemaining = 300;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final user = _authService.auth.currentUser;
    if (user != null) {
      final uid = user.uid;
      setState(() {
        _emailController.text = user.email!;
        _currentUID = uid;
      });

      final userData = await _firestoreService.getUserByUID(uid);
      if (userData != null) {
        setState(() {
          _firstNameController.text = userData['firstName'] ?? '';
          _lastNameController.text = userData['lastName'] ?? '';
        });
      }
    }
  }

  void _updateProfile(BuildContext context) async {
    final user = _authService.auth.currentUser;
    if (user != null) {
      try {
        // Update email in Firebase Auth
        await user.updateEmail(_emailController.text);
        await user.reload();
        _authService.auth.currentUser!.sendEmailVerification();

        // Update Firestore
        await _firestoreService.updateUser({
          'uid': user.uid,
          'email': _emailController.text,
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
        });

        // Save updated profile settings
        _settingsManager.updateUserSetting('email', _emailController.text);
        _settingsManager.updateUserSetting('firstName', _firstNameController.text);
        _settingsManager.updateUserSetting('lastName', _lastNameController.text);

        // Show pop-up message (Snackbar)
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile updated successfully'),
              duration: Duration(seconds: 5), // Toast duration
            ),
          );
        }
      } catch (e) {
        print('Failed to update profile: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to update profile'),
              duration: Duration(seconds: 5), // Toast duration
            ),
          );
        }
      }
    }
  }

  void _changePassword(BuildContext context) async {
    final user = _authService.auth.currentUser;
    if (user != null) {
      try {
        await _authService.resetPassword(user.email!);
        // Show pop-up message (Snackbar)
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('An email has been sent to your email. Wait 5 minutes before clicking again.'),
              duration: Duration(seconds: 5), // Toast duration
            ),
          );
        }

        // Disable the button and start the timer
        setState(() {
          _isButtonDisabled = true;
          _secondsRemaining = 300;
        });

        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (_secondsRemaining > 0) {
            setState(() {
              _secondsRemaining--;
            });
          } else {
            setState(() {
              _isButtonDisabled = false;
              _timer?.cancel();
            });
          }
        });
      } catch (e) {
        print('Failed to change password: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to change password'),
              duration: Duration(seconds: 5), // Toast duration
            ),
          );
        }
      }
    }
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: true,
          backgroundColor: biegecolor,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: biegecolor,
            title: const Text('Account Settings'),
            leading: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const SettingsScreen();
                  }),
                );
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints.expand(height: 500, width: 500),
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const ImageIcon(
                      AssetImage("icons/userprofile.png"),
                      color: Colors.black,
                      size: 50.0,
                    ),
                    const SizedBox(height: 10),
                    const SelectionContainer.disabled(
                      child: Text('First Name:'),
                    ),
                    TextField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        hintText: 'First Name',
                      ),
                      onChanged: (value) => _settingsManager.updateUserSetting('firstName', value), // Save on change
                    ),
                    const SizedBox(height: 10),
                    const SelectionContainer.disabled(
                      child: Text('Last Name:'),
                    ),
                    TextField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        hintText: 'Last Name',
                      ),
                      onChanged: (value) => _settingsManager.updateUserSetting('lastName', value), // Save on change
                    ),
                    const SizedBox(height: 10),
                    const SelectionContainer.disabled(
                      child: Text('Email Address:'),
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        hintText: 'Email Address',
                      ),
                      onChanged: (value) => _settingsManager.updateUserSetting('email', value), // Save on change
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(200, 50),
                        backgroundColor: _isButtonDisabled ? disablecolor : lgreencolor, // Dark gray when disabled, lgreencolor otherwise
                        foregroundColor: _isButtonDisabled ? Colors.white : biegecolor, // White font when disabled
                      ),
                      onPressed: _isButtonDisabled ? null : () => _changePassword(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Change Password"),
                          if (_isButtonDisabled)
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                _formatTime(_secondsRemaining), // Format MM:SS
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(200, 50),
                        backgroundColor: lgreencolor,
                        foregroundColor: biegecolor,
                      ),
                      onPressed: () => _updateProfile(context),
                      child: const Text("Update Profile"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
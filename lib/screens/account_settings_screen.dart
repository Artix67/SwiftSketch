import 'dart:async';
import 'package:flutter/material.dart';
import '../app_colors.dart';
import '/screens/settingsscreen.dart';
import '/FirebaseAuthService.dart';
import '/FirestoreService.dart';
import '/SettingsManager.dart';
import 'loginscreen.dart';

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
  final SettingsManager _settingsManager =
      SettingsManager(); // Initialize SettingsManager
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
        _settingsManager.updateUserSetting(
            'firstName', _firstNameController.text);
        _settingsManager.updateUserSetting(
            'lastName', _lastNameController.text);

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
              content: Text(
                  'An email has been sent to your email. Wait 5 minutes before clicking again.'),
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
    return Drawer(
      backgroundColor: beigecolor,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Account Settings',
            style: TextStyle(color: blackcolor, fontSize: 24),
          ),

          // Taylor - This should only be here if you can upload a profile picture. Otherwise it implies that you could.
          // const ImageIcon(
          //   AssetImage("icons/userprofile.png"),
          //   color: blackcolor,
          //   size: 50.0,
          // ),

          const SizedBox(height: 20),
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
              controller: _firstNameController,
              style:
              const TextStyle(fontSize: 14, color: blackcolor),
              textAlignVertical: TextAlignVertical.center,
              obscureText: false,
              decoration: const InputDecoration(
                hintText: "First Name",
                hintStyle: TextStyle(color: placeholdercolor),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 10, vertical: 8),
              ),
              onChanged: (value) =>
                  _settingsManager.updateUserSetting('firstName', value),
            ),
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
              controller: _lastNameController,
              style:
              const TextStyle(fontSize: 14, color: blackcolor),
              textAlignVertical: TextAlignVertical.center,
              obscureText: false,
              decoration: const InputDecoration(
                hintText: "Last Name",
                hintStyle: TextStyle(color: placeholdercolor),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 10, vertical: 8),
              ),
              onChanged: (value) =>
                  _settingsManager.updateUserSetting('lastName', value),
            ),
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
                hintText: "Email Address",
                hintStyle: TextStyle(color: placeholdercolor),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                    horizontal: 10, vertical: 8),
              ),
              onChanged: (value) =>
                  _settingsManager.updateUserSetting('email', value),
            ),
          ),
          const SizedBox(height: 20),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: lgreencolor,
              foregroundColor: whitecolor,
            ),
            onPressed: () => _updateProfile(context),
            child: const Text("Update Profile"),
          ),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                      //This will need to be changed to Navigator.pushNamedAndRemoveUntil(context, ## your routename here ##, (_) => false);
                      context,
                      //This will make it so that since were logging out the user can never return to this screen completely emptying the
                      MaterialPageRoute(builder: (context) {
                    //navigator stack
                    return const LoginScreen();
                  }));
                },
                child: const Text(
                  'Log Out',
                  style: TextStyle(
                    color: redcolor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed:
                _isButtonDisabled ? null : () => _changePassword(context),
                child: Text(
                  'Reset Password',
                  style: TextStyle(
                    color: _isButtonDisabled ? disablecolor : bluecolor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
          if (_isButtonDisabled)
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                _formatTime(_secondsRemaining), // Format MM:SS
                style: const TextStyle(color: whitecolor),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

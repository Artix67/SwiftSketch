import 'package:flutter/material.dart';
import 'package:swift_sketch/screens/homescreen.dart';
import '/screens/settingsscreen.dart';
import '/FirebaseAuthService.dart';
import '/FirestoreService.dart';
import '/SettingsManager.dart';


const Color dgreencolor = Color(0xFF181C14);
const Color lgreencolor = Color(0xFF697565);
const Color biegecolor = Color(0xFFCBC2B4);
const Color redcolor = Color(0xFFAB3E2B);
const Color bluecolor = Color(0xFF11487A);
const Color blackcolor = Color(0xFF181818);
const Color midgreencolor = Color(0xFF3C3D37);
const Color whitecolor = Color(0xFFEEEEEE);


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

  void _updateProfile() async {
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

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      } catch (e) {
        print('Failed to update profile: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile')),
        );
      }
    }
  }

  void _changePassword() async {
    final user = _authService.auth.currentUser;
    if (user != null) {
      try {
        await _authService.resetPassword(user.email!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset email sent')),
        );
      } catch (e) {
        print('Failed to change password: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to change password')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
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
                  return const HomeScreen();
                }),
              );
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints.expand(height: 475, width: 450),
            child: Container(
              decoration: BoxDecoration(
              color: whitecolor,
              borderRadius: BorderRadius.circular(12),
            ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30,),
                  const ImageIcon(
                    AssetImage("icons/userprofile.png"),
                    color: Colors.black,
                    size: 50.0,
                  ),
                  const SizedBox(height: 10),

                   Container(
                    width: 300,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                             SizedBox(width: 8,),
                             SelectionContainer.disabled(
                              child: Text('First Name:'),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 300,
                          child: TextField(
                            maxLines: 1,
                            controller: _firstNameController,
                            decoration:  InputDecoration(
                              hintText: 'First Name',
                              contentPadding: EdgeInsets.all(8),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) => _settingsManager.updateUserSetting('firstName', value), // Save on change
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    width: 300,
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            SizedBox(width: 8,),
                            SelectionContainer.disabled(
                              child: Text('Last Name:'),
                            ),
                        ],),
                        SizedBox(
                          width: 300,
                          child: TextField(
                            maxLines: 1,
                            controller: _lastNameController,
                            decoration: const InputDecoration(
                              hintText: 'Last Name',
                              contentPadding: EdgeInsets.all(8),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) => _settingsManager.updateUserSetting('lastName', value), // Save on change
                          ),
                        ),
                      ],
                    ),
                  ),




                  const SizedBox(height: 10),

                  Container(
                    width: 300,
                    child:  Column(
                      children: [
                        const Row(
                          children: [
                            SizedBox(width: 8,),
                            SelectionContainer.disabled(
                              child: Text('Email Address:'),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 300,
                          child: TextField(
                            maxLines: 1,
                            controller: _emailController,
                            decoration: const InputDecoration(
                              hintText: 'Email Address',
                              contentPadding: EdgeInsets.all(8),
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) => _settingsManager.updateUserSetting('email', value), // Save on change
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(minimumSize: const Size(200, 50),
                        backgroundColor: lgreencolor,
                      foregroundColor: biegecolor
                    ),

                    onPressed: _changePassword,
                    child: const Text("Change Password"),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(minimumSize: const Size(200, 50),
                        backgroundColor: lgreencolor,
                        foregroundColor: biegecolor
                    ),
                    onPressed: _updateProfile,
                    child: const Text("Update Profile"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
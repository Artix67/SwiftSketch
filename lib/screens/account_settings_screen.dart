import 'package:flutter/material.dart';
import '/screens/settingsscreen.dart';
import '/FirebaseAuthService.dart';
import '/FirestoreService.dart';

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

  void _deleteAccount() async {
    final user = _authService.auth.currentUser;
    if (user != null) {
      try {
        await _firestoreService.deleteUser(user.uid);
        await user.delete();
        Navigator.pushNamedAndRemoveUntil(context, '/', (Route<dynamic> route) => false);
      } catch (e) {
        print('Failed to delete account: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete account')),
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
        backgroundColor: Colors.orange[100],
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.orange[100],
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
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(minimumSize: const Size(200, 50)),
                    onPressed: _deleteAccount,
                    child: const Text("Delete Account"),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(minimumSize: const Size(200, 50)),
                    onPressed: _changePassword,
                    child: const Text("Change Password"),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(minimumSize: const Size(200, 50)),
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
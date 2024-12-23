import 'package:cloud_firestore/cloud_firestore.dart';
import 'FirebaseAuthService.dart';

class SettingsManager {
  final FirebaseAuthService _authService = FirebaseAuthService();

  Future<Map<String, dynamic>> loadUserSettings() async {
    final user = _authService.auth.currentUser;
    if (user != null) {
      var userSettings = await FirebaseFirestore.instance
          .collection('userSettings')
          .doc(user.uid)
          .get();

      if (userSettings.exists) {
        return userSettings.data() as Map<String, dynamic>;
      }
    }
    return {};
  }

  Future<void> saveUserSettings(Map<String, dynamic> settings) async {
    final user = _authService.auth.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('userSettings')
          .doc(user.uid)
          .set(settings);
    }
  }

  Future<void> updateUserSetting(String key, dynamic value) async {
    final user = _authService.auth.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('userSettings')
          .doc(user.uid)
          .update({key: value});
    }
  }
}
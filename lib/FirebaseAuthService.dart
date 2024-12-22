import 'package:firebase_auth/firebase_auth.dart';
import 'FirestoreService.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  FirebaseAuth get auth => _auth; // Public getter for _auth

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return result.user;
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = userCredential.user;
    if (user != null) {
      await _firestoreService.addUser({
        'email': email,
      });
      await _firestoreService.addSettings({
        'userEmail': email,
        'theme': 'Light',
        'toolbarPosition': 'Top',
        'fontSize': '12',
        'gridSize': '10',
        'layerPresets': 'Layer 1',
        'gridVisibility': 1,
        'tipsTutorials': 1,
        'appUpdates': 1,
        'gridSize': 0.0,
        'defaultColor': 'FFFFFF',
        'defaultTool': '',
        'gridSnapOnOff': 0,
        'gridOnOff': 0,
        'currentProject': '',
        'snapSensitivity': 0.0,
        'biometricEnabled': 0,
        'unitOfMeasurement': 'Metric',
        'snapToGridSensitivity': '10px',
        'zoomSensitivity': '10',
        'autoSaveFrequency': '5 min'
      });
    }
    return user;
  }

  Future<void> sendEmailVerification(User user) async {
    await user.sendEmailVerification();
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}


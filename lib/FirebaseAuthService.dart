import 'package:firebase_auth/firebase_auth.dart';
import 'SQLiteDatabase.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseHelper _dbHelper = DatabaseHelper();

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
      await _dbHelper.insertUser({
        'email': email,
      });
      await _dbHelper.insertSettings({
        'userEmail': email,
        'gridSize': 0.0,
        'defaultColor': 'FFFFFF',
        'defaultTool': '',
        'gridSnapOnOff': 0,
        'gridOnOff': 0,
        'currentProject': '',
        'snapSensitivity': 0.0,
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

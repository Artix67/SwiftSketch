import 'package:firebase_auth/firebase_auth.dart';
import 'FirestoreService.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  FirebaseAuth get auth => _auth;

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
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        await user.sendEmailVerification();

        await _firestoreService.addUser({
          'uid': user.uid,
          'email': email,
        });

        await _firestoreService.addSettings({
          'userUID': user.uid,
          'toolbarPosition': 'Top',
          'gridSize': '10',
          'gridVisibility': 1,
          'lineThickness': 0.0,
          'snapToGridSensitivity': '10px',
          'zoomSensitivity': '10',
        });

        // Add an initial project to Firestore
        await _firestoreService.addProject({
          'id': 'initialproject${user.uid}',
          'userUID': user.uid,
          'name': 'Welcome Project',
          'date': DateTime.now().toIso8601String(),
          'jsonData': '{}',
        });

        // Sign in the user automatically after account creation and Firestore operations
        await signInWithEmailAndPassword(email, password);

        return user;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'too-many-requests') {
        print('Too many requests. Try again later.');
        throw FirebaseAuthException(
          code: 'too-many-requests',
          message: 'Too many requests. Please try again later.',
        );
      } else {
        print('Account creation failed: ${e.message}');
        throw FirebaseAuthException(
          code: e.code,
          message: e.message,
        );
      }
    } catch (e) {
      print('An unknown error occurred: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

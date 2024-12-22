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
        // Send email verification
        await user.sendEmailVerification();

        // Ensure user is authenticated before performing Firestore operations
        // Add user to Firestore
        await _firestoreService.addUser({
          'uid': user.uid,
          'email': email,
        });

        // Add settings to Firestore
        await _firestoreService.addSettings({
          'userUID': user.uid,
          'theme': 'Light',
          'toolbarPosition': 'Top',
          'fontSize': '12',
          'gridSize': '10',
          'layerPresets': 'Layer 1',
          'gridVisibility': 1,
          'tipsTutorials': 1,
          'appUpdates': 1,
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
          'autoSaveFrequency': '5 min',
        });

        // Add an initial project to Firestore
        await _firestoreService.addProject({
          'id': 'initial_project_${user.uid}',
          'userUID': user.uid,
          'name': 'Welcome Project',
          'date': DateTime.now().toIso8601String(),
          'jsonData': '{}', // Initial empty JSON data
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

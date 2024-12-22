import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a user to Firestore
  Future<void> addUser(Map<String, dynamic> user) async {
    await _firestore.collection('users').doc(user['uid']).set(user);
  }

  // Get a user from Firestore by UID
  Future<Map<String, dynamic>?> getUserByUID(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>?;
    }
    return null;
  }

  // Update a user in Firestore
  Future<void> updateUser(Map<String, dynamic> user) async {
    await _firestore.collection('users').doc(user['uid']).update(user);
  }

  // Delete a user from Firestore
  Future<void> deleteUser(String uid) async {
    await _firestore.collection('users').doc(uid).delete();
  }

  // Add settings to Firestore
  Future<void> addSettings(Map<String, dynamic> settings) async {
    await _firestore.collection('settings').doc(settings['userUID']).set(settings);
  }

  // Get settings from Firestore by userUID
  Future<Map<String, dynamic>?> getSettings(String userUID) async {
    DocumentSnapshot doc = await _firestore.collection('settings').doc(userUID).get();
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>?;
    }
    return null;
  }

  // Update settings in Firestore
  Future<void> updateSettings(Map<String, dynamic> settings) async {
    await _firestore.collection('settings').doc(settings['userUID']).update(settings);
  }

  // Delete settings from Firestore
  Future<void> deleteSettings(String userUID) async {
    await _firestore.collection('settings').doc(userUID).delete();
  }

  // Add a project to Firestore
  Future<void> addProject(Map<String, dynamic> project) async {
    await _firestore.collection('projects').doc(project['id'].toString()).set(project);
  }

  // Get projects from Firestore by userUID
  Future<List<Map<String, dynamic>>> getProjects(String userUID) async {
    QuerySnapshot snapshot = await _firestore.collection('projects').where('userUID', isEqualTo: userUID).get();
    return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  // Update a project in Firestore
  Future<void> updateProject(Map<String, dynamic> project) async {
    await _firestore.collection('projects').doc(project['id'].toString()).update(project);
  }

  // Delete a project from Firestore
  Future<void> deleteProject(int id) async {
    await _firestore.collection('projects').doc(id.toString()).delete();
  }

  // Load a project JSON from Firestore by project ID
  Future<String?> loadProjectJson(String projectId) async {
    DocumentSnapshot doc = await _firestore.collection('projects').doc(projectId).get();
    if (doc.exists) {
      final data = doc.data() as Map<String, dynamic>?;
      return data?['jsonData'] as String?;
    }
    return null;
  }

  // Save a project JSON to Firestore
  Future<void> saveProjectJson(String projectId, String jsonData) async {
    await _firestore.collection('projects').doc(projectId).update({'jsonData': jsonData});
  }
}
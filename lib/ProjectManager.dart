import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'FirebaseAuthService.dart';
import 'package:swift_sketch/drawing_shapes/drawing_shape.dart';

class ProjectManager {
  final FirebaseAuthService _authService = FirebaseAuthService();

  Future<void> saveProject(String projectName, List<DrawingShape> shapes) async {
    final user = _authService.auth.currentUser;
    if (user != null) {
      String jsonData = _convertShapesToJson(shapes);
      var existingProject = await FirebaseFirestore.instance
          .collection('projects')
          .where('userUID', isEqualTo: user.uid)
          .where('name', isEqualTo: projectName)
          .get();

      if (existingProject.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('projects')
            .doc(existingProject.docs.first.id)
            .update({
          'jsonData': jsonData,
          'date': DateTime.now().toIso8601String(),
        });
      } else {
        await FirebaseFirestore.instance.collection('projects').add({
          'userUID': user.uid,
          'name': projectName,
          'date': DateTime.now().toIso8601String(),
          'jsonData': jsonData,
        });
      }
    }
  }

  Future<List<DrawingShape>> loadProject(String projectName) async {
    final user = _authService.auth.currentUser;
    if (user != null) {
      var existingProject = await FirebaseFirestore.instance
          .collection('projects')
          .where('userUID', isEqualTo: user.uid)
          .where('name', isEqualTo: projectName)
          .get();

      if (existingProject.docs.isNotEmpty) {
        var jsonData = existingProject.docs.first.data()['jsonData'];
        List<dynamic> shapesJson = jsonDecode(jsonData);
        List<DrawingShape> shapes = shapesJson.map((shape) => DrawingShape.fromJson(shape)).toList();
        return shapes;
      }
    }
    return [];
  }

  String _convertShapesToJson(List<DrawingShape> shapes) {
    List<Map<String, dynamic>> shapeData = shapes.map((shape) => shape.toJson()).toList();
    return jsonEncode(shapeData);
  }
}
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'FirebaseAuthService.dart';
import '../models/layer.dart';

class ProjectManager {
  final FirebaseAuthService _authService = FirebaseAuthService();

  Future<void> saveProject(String projectName, List<Layer> layers) async {
    final user = _authService.auth.currentUser;
    print(user?.uid);
    if (user != null) {
      String jsonData = _convertLayersToJson(layers);
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

  Future<List<Layer>> loadProject(String projectName) async {
    final user = _authService.auth.currentUser;
    if (user != null) {
      var existingProject = await FirebaseFirestore.instance
          .collection('projects')
          .where('userUID', isEqualTo: user.uid)
          .where('name', isEqualTo: projectName)
          .get();

      if (existingProject.docs.isNotEmpty) {
        var jsonData = existingProject.docs.first.data()['jsonData'];
        print('Loaded JSON Data: $jsonData');
        List<dynamic> layersJson = jsonDecode(jsonData);
        List<Layer> layers = layersJson.map((layerJson) => Layer.fromJson(layerJson)).toList();
        print('Deserialized Layers: $layers');
        return layers;
      }
    }
    return [];
  }

  String _convertLayersToJson(List<Layer> layers) {
    List<Map<String, dynamic>> layerData = layers.map((layer) => layer.toJson()).toList();
    return jsonEncode(layerData);
  }
}
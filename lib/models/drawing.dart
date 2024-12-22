import 'dart:convert';
import 'layer.dart';

class Drawing {
  final String id;
  final String title;
  final DateTime createdAt;
  final List<Layer> layers;

  Drawing({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.layers,
  });

  // Convert a Drawing to a JSON-friendly map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'layers': layers.map((layer) => layer.toJson()).toList(),
    };
  }

  // Create a Drawing from JSON.
  factory Drawing.fromJson(Map<String, dynamic> json) {
    return Drawing(
      id: json['id'],
      title: json['title'],
      createdAt: DateTime.parse(json['createdAt']),
      layers: (json['layers'] as List)
          .map((layerJson) => Layer.fromJson(layerJson))
          .toList(),
    );
  }

  // Helper method to convert a Drawing to a JSON string.
  String toJsonString() => jsonEncode(toJson());

  // Factory to create a Drawing from a JSON string.
  factory Drawing.fromJsonString(String jsonString) {
    return Drawing.fromJson(jsonDecode(jsonString));
  }
}
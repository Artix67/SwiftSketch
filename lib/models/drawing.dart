import 'dart:convert';
import '../drawing_shapes/drawing_shape.dart';

class Drawing {
  final String id;
  final String title;
  final DateTime createdAt;
  final List<DrawingShape> shapes;

  Drawing({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.shapes,
  });

  // Method to convert a Drawing object to a JSON-friendly map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'shapes': shapes.map((shape) => shape.toJson()).toList(),
    };
  }

  // Factory to create a Drawing object from JSON.
  factory Drawing.fromJson(Map<String, dynamic> json) {
    return Drawing(
      id: json['id'],
      title: json['title'],
      createdAt: DateTime.parse(json['createdAt']),
      shapes: (json['shapes'] as List)
          .map((shapeJson) => DrawingShape.fromJson(shapeJson))
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
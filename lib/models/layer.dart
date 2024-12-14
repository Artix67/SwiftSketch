import '../drawing_shapes/drawing_shape.dart';

class Layer {
  final String id;
  final String name;
  final bool isVisible;
  final List<DrawingShape> shapes;

  Layer({
    required this.id,
    required this.name,
    this.isVisible = true,
    required this.shapes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isVisible': isVisible,
      'shapes': shapes.map((shape) => shape.toJson()).toList(),
    };
  }

  factory Layer.fromJson(Map<String, dynamic> json) {
    return Layer(
      id: json['id'],
      name: json['name'],
      isVisible: json['isVisible'],
      shapes: (json['shapes'] as List)
          .map((shapeJson) => DrawingShape.fromJson(shapeJson))
          .toList(),
    );
  }
}

import 'package:flutter/material.dart';

class DrawingShape {
  final List<Offset?> points;
  final Path path;
  final String toolType;

  DrawingShape({required this.points, required this.toolType})
      : path = _generatePath(points);

  // Method to convert points to a serializable JSON-friendly format
  Map<String, dynamic> toJson() {
    return {
      'points': points.map((point) => point != null ? {'x': point.dx, 'y': point.dy} : null).toList(),
      'toolType': toolType,
    };
  }

  // Factory to create a DrawingShape from JSON
  factory DrawingShape.fromJson(Map<String, dynamic> json) {
    List<Offset?> points = (json['points'] as List)
        .map((point) => point != null ? Offset(point['x'], point['y']) : null)
        .toList();
    return DrawingShape(
      points: points,
      toolType: json['toolType'],
    );
  }

  static Path _generatePath(List<Offset?> points) {
    Path path = Path();
    if (points.isNotEmpty && points[0] != null) {
      path.moveTo(points[0]!.dx, points[0]!.dy);
      for (Offset? point in points) {
        if (point != null) {
          path.lineTo(point.dx, point.dy);
        }
      }
    }
    return path;
  }

  bool containsPoint(Offset point) {
    return path.contains(point);
  }
}
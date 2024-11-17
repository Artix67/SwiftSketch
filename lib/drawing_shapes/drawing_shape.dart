import '/drawing_tools/drawing_tool.dart';
import 'package:flutter/material.dart';

class DrawingShape {
  final List<Offset?> points;
  final Path path;
  final DrawingTool tool;

  DrawingShape({required this.points, required this.tool})
      : path = _generatePath(points);

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
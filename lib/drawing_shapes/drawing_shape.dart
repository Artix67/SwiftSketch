import 'package:flutter/material.dart';
import '/drawing_tools/drawing_tool.dart';
import '/drawing_tools/freeform_tool.dart';
import '/drawing_tools/line_tool.dart';
import '/drawing_tools/circle_tool.dart';
import '/drawing_tools/rectangle_tool.dart';
import '/drawing_tools/triangle_tool.dart';

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

  Map<String, dynamic> toJson() {
    return {
      'points': points.map((point) => point != null ? {'x': point.dx, 'y': point.dy} : null).toList(),
      'tool': tool.runtimeType.toString(),
    };
  }

  static DrawingShape fromJson(Map<String, dynamic> json) {
    List<Offset?> points = (json['points'] as List)
        .map((point) => point != null ? Offset(point['x'], point['y']) : null)
        .toList();
    DrawingTool tool;

    switch (json['tool']) {
      case 'FreeformTool':
        tool = FreeformTool();
        break;
      case 'LineTool':
        tool = LineTool();
        break;
      case 'CircleTool':
        tool = CircleTool();
        break;
      case 'RectangleTool':
        tool = RectangleTool();
        break;
      case 'TriangleTool':
        tool = TriangleTool();
        break;
      default:
        tool = FreeformTool();
    }

    return DrawingShape(points: points, tool: tool);
  }
}

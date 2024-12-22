import 'package:flutter/material.dart';
import '/drawing_tools/drawing_tool.dart';
import '/drawing_tools/freeform_tool.dart';
import '/drawing_tools/line_tool.dart';
import '/drawing_tools/circle_tool.dart';
import '/drawing_tools/rectangle_tool.dart';
import '/drawing_tools/triangle_tool.dart';
import '/drawing_tools/annotation_tool.dart';

class DrawingShape {
  final List<Offset?> points;
  final Path path;
  final String toolType;
  final Color fillColor;
  final Color strokeColor;
  final double strokeWidth;
  final String? annotation;
  final DrawingTool tool;

  DrawingShape({
    required this.points,
    required this.toolType,
    required this.fillColor,
    required this.strokeColor,
    required this.strokeWidth,
    this.annotation,
    required this.tool,
  }) : path = _generatePath(points);

  // Method to convert points to a serializable JSON-friendly format
  Map<String, dynamic> toJson() {
    return {
      'points': points.map((point) => point != null ? {'x': point.dx, 'y': point.dy} : null).toList(),
      'toolType': toolType,
      'fillColor': fillColor.value,
      'strokeColor': strokeColor.value,
      'strokeWidth': strokeWidth,
      'tool': tool.runtimeType.toString(),
      'annotation': annotation,
    };
  }

  // Factory to create a DrawingShape from JSON
  factory DrawingShape.fromJson(Map<String, dynamic> json) {
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
      case 'AnnotationTool':
        tool = AnnotationTool();
        break;
      default:
        tool = FreeformTool();
    }

    return DrawingShape(
      points: points,
      toolType: json['toolType'],
      fillColor: Color(json['fillColor']),
      strokeColor: Color(json['strokeColor']),
      strokeWidth: json['strokeWidth'] ?? 1.0,
      tool: tool,
      annotation: json['annotation'],
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

  DrawingShape copy() {
    return DrawingShape(
      points: List.from(this.points),
      toolType: this.toolType,
      fillColor: this.fillColor,
      strokeColor: this.strokeColor,
      strokeWidth: this.strokeWidth,
      annotation: this.annotation,
      tool: this.tool,
    );
  }
}
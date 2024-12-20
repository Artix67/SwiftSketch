import 'drawing_tool.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class CircleTool implements DrawingTool {
  Offset? _startPoint;
  Offset? _currentPosition;
  bool _snapToGrid = false;

  CircleTool({bool snapToGrid = false}) {
    _snapToGrid = snapToGrid;
  }

  @override
  void onPanStart(Offset position, List<Offset?> points) {
    _startPoint = _snapToGrid ? snapToGrid(position, 10.0) : position;
    _currentPosition = null;
  }

  @override
  void onPanUpdate(Offset position, List<Offset?> points) {
    if (_startPoint != null) {
      _currentPosition = _snapToGrid ? snapToGrid(position, 10.0) : position;

      // Calculate the center point between start and current position
      Offset center = Offset(
        (_startPoint!.dx + _currentPosition!.dx) / 2,
        (_startPoint!.dy + _currentPosition!.dy) / 2,
      );

      // Calculate the radius as half the distance between start and current position
      double radius = (_startPoint! - _currentPosition!).distance / 2;

      points.clear();
      // Generate points for the circle
      for (double angle = 0; angle < 2 * pi; angle += pi / 180) {
        double radians = angle;
        Offset circlePoint = Offset(
          center.dx + radius * cos(radians),
          center.dy + radius * sin(radians),
        );
        points.add(circlePoint);
      }
    }
  }

  @override
  void onPanEnd(Offset position, List<Offset?> points) {
    if (_startPoint != null && _currentPosition != null) {
      Offset center = Offset(
        (_startPoint!.dx + _currentPosition!.dx) / 2,
        (_startPoint!.dy + _currentPosition!.dy) / 2,
      );

      double radius = (_startPoint! - _currentPosition!).distance / 2;

      points.clear();

      for (double angle = 0; angle < 2 * pi; angle += pi / 180) {
        double radians = angle;
        Offset circlePoint = Offset(
          center.dx + radius * cos(radians),
          center.dy + radius * sin(radians),
        );
        points.add(circlePoint);
      }

      points.add(null);
    }
    _startPoint = null;
    _currentPosition = null;
  }

  @override
  Offset? get previewStart => _startPoint;

  @override
  Offset? get previewEnd => _currentPosition;

  Offset snapToGrid(Offset point, double gridSize) {
    double snappedX = (point.dx / gridSize).round() * gridSize;
    double snappedY = (point.dy / gridSize).round() * gridSize;
    return Offset(snappedX, snappedY);
  }

  @override
  void setSnapToGrid(bool value) {
    _snapToGrid = value;
  }

  @override
  bool shouldSnapToGrid() => true;
}
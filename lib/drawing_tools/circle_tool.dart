import '/drawing_tool.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class CircleTool implements DrawingTool {
  Offset? _startPoint;
  Offset? _currentPosition;

  @override
  void onPanStart(Offset position, List<Offset?> points) {
    _startPoint = position;
    _currentPosition = null;
  }

  @override
  void onPanUpdate(Offset position, List<Offset?> points) {
    if (_startPoint != null) {
      _currentPosition = position;

      final double radius = (_startPoint! - _currentPosition!).distance;

      points.clear();
      for (double angle = 0; angle < 2 * pi; angle += pi / 180) {
        double radians = angle;
        Offset circlePoint = Offset(
          _startPoint!.dx + radius * cos(radians),
          _startPoint!.dy + radius * sin(radians),
        );
        points.add(circlePoint);
      }
    }
  }

  @override
  void onPanEnd(Offset position, List<Offset?> points) {
    if (_startPoint != null && _currentPosition != null) {
      final double radius = (_startPoint! - _currentPosition!).distance;

      points.clear();
      for (double angle = 0; angle < 2 * pi; angle += pi / 180) {
        double radians = angle;
        Offset circlePoint = Offset(
          _startPoint!.dx + radius * cos(radians),
          _startPoint!.dy + radius * sin(radians),
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
}
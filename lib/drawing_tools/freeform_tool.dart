import 'drawing_tool.dart';
import 'package:flutter/material.dart';

class FreeformTool implements DrawingTool {
  Offset? _lastPoint;

  @override
  void onPanStart(Offset position, List<Offset?> points) {
    points.add(position);
    _lastPoint = position;
  }

  @override
  void onPanUpdate(Offset position, List<Offset?> points) {
    points.add(position);
    _lastPoint = position;
  }

  @override
  void onPanEnd(Offset position, List<Offset?> points) {
    points.add(null);
    _lastPoint = null;
  }

  @override
  Offset? get previewStart => null;

  @override
  Offset? get previewEnd => _lastPoint;

  @override
  void setSnapToGrid(bool value) {} //freeform does not snap

  @override
  bool shouldSnapToGrid() => false;
}
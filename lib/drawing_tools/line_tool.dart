import 'drawing_tool.dart';
import 'package:flutter/material.dart';

class LineTool implements DrawingTool {
  Offset? _startPoint;
  Offset? _currentPosition;
  bool _snapToGrid = false;

  LineTool({bool snapToGrid = false}) {
    _snapToGrid = snapToGrid;
  }

  @override
  void onPanStart(Offset position, List<Offset?> points) {
    _startPoint = _snapToGrid ? snapToGrid(position, 10.0) : position;
    _currentPosition = _snapToGrid ? snapToGrid(position, 10.0) : position;
  }

  @override
  void onPanUpdate(Offset position, List<Offset?> points) {
    if (_startPoint != null) {
      _currentPosition = _snapToGrid ? snapToGrid(position, 10.0) : position;

      points.clear();

      points.add(_startPoint);
      points.add(_currentPosition);
    }
  }

  @override
  void onPanEnd(Offset position, List<Offset?> points) {
    if (_startPoint != null) {
      points.add(_startPoint);
      points.add(_snapToGrid ? snapToGrid(position, 10.0) : position);
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
}
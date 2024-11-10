import '/drawing_tool.dart';
import 'package:flutter/material.dart';

class LineTool implements DrawingTool {
  Offset? _startPoint;
  Offset? _currentPosition;

  @override
  void onPanStart(Offset position, List<Offset?> points) {
    _startPoint = position;
    _currentPosition = position;
  }

  @override
  void onPanUpdate(Offset position, List<Offset?> points) {
    if (_startPoint != null) {
      _currentPosition = position;

      points.clear();

      points.add(_startPoint);
      points.add(_currentPosition);
    }
  }

  @override
  void onPanEnd(Offset position, List<Offset?> points) {
    if (_startPoint != null) {
      points.add(_startPoint);
      points.add(position);
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
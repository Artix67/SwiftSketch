import '/drawing_tool.dart';
import 'package:flutter/material.dart';

class RectangleTool implements DrawingTool {
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

      points.clear();
      points.add(_startPoint);
      points.add(Offset(_currentPosition!.dx, _startPoint!.dy));
      points.add(_currentPosition);
      points.add(Offset(_startPoint!.dx, _currentPosition!.dy));
      points.add(_startPoint);
    }
  }

  @override
  void onPanEnd(Offset position, List<Offset?> points) {
    if (_startPoint != null && _currentPosition != null) {

      points.add(_startPoint);
      points.add(Offset(_currentPosition!.dx, _startPoint!.dy));
      points.add(_currentPosition);
      points.add(Offset(_startPoint!.dx, _currentPosition!.dy));
      points.add(_startPoint);
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
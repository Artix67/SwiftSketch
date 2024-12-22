import 'package:flutter/material.dart';
import '/drawing_tools/drawing_tool.dart';

class AnnotationTool extends DrawingTool {
  Offset? _start;
  Offset? _end;
  bool _snapToGrid = true;

  @override
  void onPanStart(Offset position, List<Offset?> points) {
    _start = _snapToGrid ? snapToGrid(position, 10.0) : position;
    _end = null;
    points.clear();
    points.add(_start);
  }

  @override
  void onPanUpdate(Offset position, List<Offset?> points) {
    _end = _snapToGrid ? snapToGrid(position, 10.0) : position;

    if (_start != null) {
      points.clear();
      points.add(_start);
      points.add(Offset(_end!.dx, _start!.dy));
      points.add(_end);
      points.add(Offset(_start!.dx, _end!.dy));
      points.add(_start);
    }
  }

  @override
  void onPanEnd(Offset position, List<Offset?> points) {
    _end = _snapToGrid ? snapToGrid(position, 10.0) : position;
    points.add(null);
  }

  Offset snapToGrid(Offset point, double gridSize) {
    double snappedX = (point.dx / gridSize).round() * gridSize;
    double snappedY = (point.dy / gridSize).round() * gridSize;
    return Offset(snappedX, snappedY);
  }

  @override
  Offset? get previewStart => _start;

  @override
  Offset? get previewEnd => _end;

  @override
  void setSnapToGrid(bool value) {
    _snapToGrid = value;
  }

  @override
  bool shouldSnapToGrid() => _snapToGrid;
}
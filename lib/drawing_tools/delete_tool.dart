import 'drawing_tool.dart';
import 'package:flutter/material.dart';
import '/drawing_shapes/drawing_shape.dart';

class DeleteTool implements DrawingTool {
  final List<DrawingShape> _shapes;
  final VoidCallback onShapeDeleted;

  DeleteTool(this._shapes, this.onShapeDeleted);

  @override
  void onPanStart(Offset position, List<Offset?> points) {}

  @override
  void onPanUpdate(Offset position, List<Offset?> points) {}

  @override
  void onPanEnd(Offset position, List<Offset?> points) {
    // Check if the position intersects with any shape and delete the top-most shape
    DrawingShape? shapeToDelete;
    for (DrawingShape shape in _shapes.reversed) {
      if (shape.containsPoint(position)) {
        shapeToDelete = shape;
        break;
      }
    }

    if (shapeToDelete != null) {
      _shapes.remove(shapeToDelete);
      onShapeDeleted(); // Call the callback to trigger setState
    }
  }

  @override
  Offset? get previewStart => null;

  @override
  Offset? get previewEnd => null;

  @override
  void setSnapToGrid(bool value) {}
}

import 'package:flutter/material.dart';
import '/drawing_shapes/drawing_shape.dart';

class UndoRedoManager {
  List<List<DrawingShape>> _undoStack = [];
  List<List<DrawingShape>> _redoStack = [];

  void addAction(List<DrawingShape> currentShapes) {
    _undoStack.add(List.from(currentShapes));
    _redoStack.clear();  // Clear the redo stack whenever a new action is added
  }

  List<DrawingShape>? undo(List<DrawingShape> currentShapes) {
    if (_undoStack.isNotEmpty) {
      _redoStack.add(List.from(currentShapes));
      return _undoStack.removeLast();
    }
    return null;
  }

  List<DrawingShape>? redo() {
    if (_redoStack.isNotEmpty) {
      _undoStack.add(List.from(_redoStack.last));
      return _redoStack.removeLast();
    }
    return null;
  }
}

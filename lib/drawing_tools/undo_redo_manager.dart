
import '/drawing_shapes/drawing_shape.dart';


class UndoRedoManager {
  List<List<DrawingShape>> _undoStack = [];
  List<List<DrawingShape>> _redoStack = [];

  void addAction(List<DrawingShape> currentShapes) {
    _undoStack.add(List.from(currentShapes));
    _redoStack.clear();  // Clear the redo stack to prevent incorrect redos after a new action
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
      List<DrawingShape> shapesToRestore = _redoStack.removeLast();
      _undoStack.add(List.from(shapesToRestore));
      return shapesToRestore;
    }
    return null;
  }
}


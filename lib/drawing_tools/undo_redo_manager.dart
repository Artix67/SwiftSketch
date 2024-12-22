
import '/models/layer.dart';

class UndoRedoManager {
  final List<List<Layer>> _undoStack = [];
  final List<List<Layer>> _redoStack = [];

  void addAction(List<Layer> currentLayers) {
    var index = _undoStack.length;
    print("Undo Stack Before: ${index}");
    _undoStack.add(currentLayers.map((layer) => layer.copy()).toList());
    _redoStack.clear();
    print("Undo Stack after: ${index}");
  }

  List<Layer> undo(List<Layer> currentLayers) {
    var index = _undoStack.length;
    print("Undo Stack Before: ${index}");
    if (index != 2) {
      if (_undoStack.isEmpty) return currentLayers;
      _redoStack.add(currentLayers.map((layer) => layer.copy()).toList());
      var changedUndoStack = _undoStack.removeAt(index - 2);
      print("Undo Stack After: ${index}");
      return changedUndoStack;
    } else {
      print("Undo Stack After: ${index}");
      return currentLayers;
    }
  }

  List<Layer> redo() {
    List<Layer> layersToRestore = _redoStack.removeLast();
    _undoStack.add(layersToRestore.map((layer) => layer.copy()).toList());
    return layersToRestore;
  }
}
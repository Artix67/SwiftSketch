
import '/models/layer.dart';


class UndoRedoManager {
  final List<List<Layer>> _undoStack = [];
  final List<List<Layer>> _redoStack = [];

  void addAction(List<Layer> currentLayers) {
    _undoStack.add(currentLayers.map((layer) => layer.copy()).toList());
    _redoStack.clear();  // Clear the redo stack to prevent incorrect redos after a new action
  }

  List<Layer>? undo(List<Layer> currentLayers) {
    if (_undoStack.isNotEmpty) {
      _redoStack.add(currentLayers.map((layer) => layer.copy()).toList());
      return _undoStack.removeLast();
    }
    return null;
  }

  List<Layer>? redo() {
    if (_redoStack.isNotEmpty) {
      List<Layer> layersToRestore = _redoStack.removeLast();
      _undoStack.add(layersToRestore.map((layer) => layer.copy()).toList());
      return layersToRestore;
    }
    return null;
  }
}


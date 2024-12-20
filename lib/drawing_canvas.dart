import 'package:flutter/material.dart';
import 'package:swift_sketch/export_drawing.dart';
import '/drawing_tools/drawing_tool.dart';
import '/drawing_tools/freeform_tool.dart';
import 'package:swift_sketch/drawing_shapes/drawing_shape.dart';
import '/drawing_tools/redo_undo_tool.dart';

class DrawingPainter extends CustomPainter {
  final List<DrawingShape> shapes;
  final List<Offset?> points;
  final List<Offset?>? previewPoints;
  final bool showGrid;

  DrawingPainter(this.shapes, this.points, {required this.previewPoints, this.showGrid = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    for (DrawingShape shape in shapes) {
      canvas.drawPath(shape.path, paint);
    }

    if (previewPoints != null && previewPoints!.isNotEmpty) {
      paint.color = Colors.black; // Preview color

      for (int i = 0; i < previewPoints!.length - 1; i++) {
        if (previewPoints![i] != null && previewPoints![i + 1] != null) {
          canvas.drawLine(previewPoints![i]!, previewPoints![i + 1]!, paint);
        }
      }
    }

    if (showGrid) {
      paint
        ..color = Colors.grey.withOpacity(0.3)
        ..strokeWidth = 0.5;

      for (double x = 0; x < size.width; x += 10) {
        canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
      }
      for (double y = 0; y < size.height; y += 10) {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) {
    return oldDelegate.shapes != shapes ||
        oldDelegate.points != points ||
        oldDelegate.previewPoints != previewPoints ||
        oldDelegate.showGrid != showGrid;
  }
}

class DrawingCanvas extends StatefulWidget {
  const DrawingCanvas({super.key});

  @override
  DrawingCanvasState createState() => DrawingCanvasState();
}

class DrawingCanvasState extends State<DrawingCanvas> {
  final GlobalKey exportGlobalKey = GlobalKey();
  final ValueNotifier<List<Offset?>> _pointsNotifier = ValueNotifier<List<Offset?>>([]);
  final ValueNotifier<List<Offset?>> _previewPointsNotifier = ValueNotifier<List<Offset?>>([]);
  final TransformationController _transformationController = TransformationController(); // Daniel - Transformation Controller added

  bool _showGrid = true;
  bool _snapToGrid = true;
  bool _isZoomEnabled = false; // Daniel - New variable to manage zoom state

  DrawingTool selectedTool = FreeformTool();
  List<DrawingShape> shapes = [];
  UndoRedoManager _undoRedoManager = UndoRedoManager(); // Undo/Redo manager initialization

  void _addShape(DrawingShape shape) {
    setState(() {
      shapes.add(shape);
      _undoRedoManager.addAction(List.from(shapes));
    });
  }

  void undo() {
    var previousShapes = _undoRedoManager.undo(shapes); // Pass the current shapes list
    if (previousShapes != null) {
      setState(() {
        shapes = previousShapes;
      });
    }
  }

  void redo() {
    var newShapes = _undoRedoManager.redo(); // Here, redo seems to not require arguments, ensure it is designed that way.
    if (newShapes != null) {
      setState(() {
        shapes = newShapes;
      });
    }
  }

  void clearCanvas() {
    setState(() {
      _pointsNotifier.value = [];
      shapes.clear();
      _undoRedoManager.addAction([]);
    });
  }

  void toggleGrid() {
    setState(() {
      _showGrid = !_showGrid;
    });
  }

  void toggleSnapToGrid() {
    setState(() {
      _snapToGrid = !_snapToGrid;
      selectedTool.setSnapToGrid(_snapToGrid);
    });
  }

  void switchTool(DrawingTool tool) {
    setState(() {
      selectedTool = tool;
      selectedTool.setSnapToGrid(_snapToGrid);
    });
  }

  void toggleZoom() {
    setState(() {
      _isZoomEnabled = !_isZoomEnabled;
      if (!_isZoomEnabled) {
        _transformationController.value = Matrix4.identity();
      }
    });
  }

  void export() {
    exportToPdf(context, exportGlobalKey);
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: exportGlobalKey,
      child: Stack(
        children: [
          GestureDetector(
            onPanStart: !_isZoomEnabled
                ? (details) {
              selectedTool.onPanStart(details.localPosition, _previewPointsNotifier.value);
              _previewPointsNotifier.value = List.from(_previewPointsNotifier.value);
            }
                : null,
            onPanUpdate: !_isZoomEnabled
                ? (details) {
              selectedTool.onPanUpdate(details.localPosition, _previewPointsNotifier.value);
              _previewPointsNotifier.value = List.from(_previewPointsNotifier.value);
            }
                : null,
            onPanEnd: !_isZoomEnabled
                ? (details) {
              selectedTool.onPanEnd(details.localPosition, _previewPointsNotifier.value);
              if (_previewPointsNotifier.value.isNotEmpty) {
                _addShape(DrawingShape(points: List.from(_previewPointsNotifier.value), tool: selectedTool));
              }
              _pointsNotifier.value = [
                ..._pointsNotifier.value,
                ..._previewPointsNotifier.value,
              ];
              _previewPointsNotifier.value = [];
            }
                : null,
            child: InteractiveViewer(
              transformationController: _transformationController,
              panEnabled: _isZoomEnabled,
              scaleEnabled: _isZoomEnabled,
              child: ValueListenableBuilder<List<Offset?>>(
                valueListenable: _pointsNotifier,
                builder: (context, points, _) {
                  return ValueListenableBuilder<List<Offset?>>(
                    valueListenable: _previewPointsNotifier,
                    builder: (context, previewPoints, _) {
                      return Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.white,
                        child: CustomPaint(
                          painter: DrawingPainter(
                            shapes,
                            points,
                            previewPoints: previewPoints,
                            showGrid: _showGrid,
                          ),
                          size: Size.infinite,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: toggleZoom,
              child: Icon(_isZoomEnabled ? Icons.zoom_out : Icons.zoom_in),
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Row(
              children: [
                FloatingActionButton(
                  onPressed: undo,
                  child: Icon(Icons.undo),
                  heroTag: null,
                ),
                SizedBox(width:10),
                FloatingActionButton(
                    onPressed: redo,
                child: Icon(Icons.redo),
                heroTag: null,
                )
              ]
            )
          )
        ],
      ),
    );
  }
}

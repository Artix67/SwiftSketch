import 'package:flutter/material.dart';
import 'package:swift_sketch/drawing_tools/rectangle_tool.dart';
import 'drawing_tools/drawing_tool.dart';
import '/drawing_tools/freeform_tool.dart';
import '/drawing_tools/line_tool.dart';
import '/drawing_tools/circle_tool.dart';
import '/drawing_tools/delete_tool.dart';
import 'package:swift_sketch/drawing_shapes/drawing_shape.dart';

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
  _DrawingCanvasState createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  final ValueNotifier<List<Offset?>> _pointsNotifier = ValueNotifier<List<Offset?>>([]);
  final ValueNotifier<List<Offset?>> _previewPointsNotifier = ValueNotifier<List<Offset?>>([]);
  bool _showGrid = false;
  bool _snapToGrid = false;

  DrawingTool _selectedTool = FreeformTool();
  List<DrawingShape> _shapes = [];

  void _addShape(DrawingShape shape) {
    setState(() {
      _shapes.add(shape);
    });
  }

  void _clearCanvas() {
    setState(() {
      _pointsNotifier.value = [];
      _shapes.clear();
    });
  }

  void _toggleGrid() {
    setState(() {
      _showGrid = !_showGrid;
    });
  }

  void _toggleSnapToGrid() {
    setState(() {
      _snapToGrid = !_snapToGrid;
      _selectedTool.setSnapToGrid(_snapToGrid);
    });
  }

  void _switchTool(DrawingTool tool) {
    setState(() {
      _selectedTool = tool;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onPanStart: (details) {
            _selectedTool.onPanStart(details.localPosition, _previewPointsNotifier.value);
            _previewPointsNotifier.value = List.from(_previewPointsNotifier.value);
          },
          onPanUpdate: (details) {
            _selectedTool.onPanUpdate(details.localPosition, _previewPointsNotifier.value);
            _previewPointsNotifier.value = List.from(_previewPointsNotifier.value);
          },
          onPanEnd: (details) {
            _selectedTool.onPanEnd(details.localPosition, _previewPointsNotifier.value);
            // Convert the completed points into a shape and add it to _shapes.
            if (_previewPointsNotifier.value.isNotEmpty) {
              _addShape(DrawingShape(points: List.from(_previewPointsNotifier.value), tool: _selectedTool));
            }
            _pointsNotifier.value = [
              ..._pointsNotifier.value,
              ..._previewPointsNotifier.value,
            ];
            _previewPointsNotifier.value = [];
          },
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
                        _shapes,
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
        Positioned(
          top: 16,
          left: 16,
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () => _switchTool(FreeformTool()),
                child: const Text("Freeform"),
              ),
              ElevatedButton(
                onPressed: () => _switchTool(LineTool()),
                child: const Text("Line"),
              ),
              ElevatedButton(
                onPressed: () => _switchTool(RectangleTool()),
                child: const Text("Rectangle"),
              ),
              ElevatedButton(
                onPressed: () => _switchTool(CircleTool()),
                child: const Text("Circle"),
              ),
              ElevatedButton(
                onPressed: () => _switchTool(DeleteTool(_shapes, () {
                  setState(() {});
                })),
                child: const Text("Delete"),
              ),
            ],
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: Row(
            children: [
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _toggleGrid,
                child: Text(_showGrid ? "Hide Grid" : "Show Grid"),
              ),
              ElevatedButton(
                onPressed: _toggleSnapToGrid,
                child: Text(_snapToGrid ? "Disable Snap" : "Enable Snap"),
              ),
              ElevatedButton(
                onPressed: _clearCanvas,
                child: const Text("Clear"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
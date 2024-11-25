import 'package:flutter/material.dart';
import 'package:swift_sketch/export_drawing.dart';
import '/drawing_tools/drawing_tool.dart';
import '/drawing_tools/freeform_tool.dart';
import '/drawing_tools/line_tool.dart';
import '/drawing_tools/rectangle_tool.dart';
import '/drawing_tools/circle_tool.dart';
import '/drawing_tools/triangle_tool.dart';
import '/drawing_tools/delete_tool.dart';
import '/drawing_shapes/drawing_shape.dart';

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
  bool _showGrid = true;
  bool _snapToGrid = true;
  String getToolTypeForTool(selectedTool) {
    if (selectedTool is FreeformTool) return 'Freeform';
    if (selectedTool is LineTool) return 'Line';
    if (selectedTool is CircleTool) return 'Circle';
    if (selectedTool is RectangleTool) return 'Rectangle';
    if (selectedTool is TriangleTool) return 'Triangle';
    if (selectedTool is DeleteTool) return 'Delete';
    throw Exception('Unknown tool type');
  }

  DrawingTool selectedTool = FreeformTool();
  List<DrawingShape> shapes = [];

  void _addShape(DrawingShape shape) {
    setState(() {
      shapes.add(shape);
    });
  }

  void clearCanvas() {
    setState(() {
      _pointsNotifier.value = [];
      shapes.clear();
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
            onPanStart: (details) {
              selectedTool.onPanStart(details.localPosition, _previewPointsNotifier.value);
              _previewPointsNotifier.value = List.from(_previewPointsNotifier.value);
            },
            onPanUpdate: (details) {
              selectedTool.onPanUpdate(details.localPosition, _previewPointsNotifier.value);
              _previewPointsNotifier.value = List.from(_previewPointsNotifier.value);
            },
            onPanEnd: (details) {
              selectedTool.onPanEnd(details.localPosition, _previewPointsNotifier.value);
              // Convert the completed points into a shape and add it to _shapes.
              if (_previewPointsNotifier.value.isNotEmpty) {
                _addShape(DrawingShape(points: List.from(_previewPointsNotifier.value), toolType: getToolTypeForTool(selectedTool)));
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
        ],
      ),
    );
  }
}
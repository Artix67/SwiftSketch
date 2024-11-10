import 'package:flutter/material.dart';
import 'package:swift_sketch/drawing_tools/rectangle_tool.dart';
import '/drawing_tool.dart';
import '/drawing_tools/freeform_tool.dart';
import '/drawing_tools/line_tool.dart';
import '/drawing_tools/circle_tool.dart';

class DrawingPainter extends CustomPainter {
  final List<Offset?> points;
  final List<Offset?>? previewPoints;
  final bool showGrid;

  DrawingPainter(this.points, {required this.previewPoints, this.showGrid = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }

    // Preview Line
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
    return oldDelegate.points != points ||
        oldDelegate.previewPoints != previewPoints ||
        oldDelegate.showGrid != showGrid;
  }
}

class DrawingCanvas extends StatefulWidget {
  @override
  _DrawingCanvasState createState() => _DrawingCanvasState();
}

class _DrawingCanvasState extends State<DrawingCanvas> {
  final ValueNotifier<List<Offset?>> _pointsNotifier = ValueNotifier<List<Offset?>>([]);
  final ValueNotifier<List<Offset?>> _previewPointsNotifier = ValueNotifier<List<Offset?>>([]);
  bool _showGrid = false;

  DrawingTool _selectedTool = FreeformTool(); // Default initialized tool

  void _clearCanvas() {
    _pointsNotifier.value = [];
  }

  void _toggleGrid() {
    setState(() {
      _showGrid = !_showGrid;
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
            // Add preview points to permanent points to make the final shape permanent
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
                child: Text("Freeform"),
              ),
              ElevatedButton(
                onPressed: () => _switchTool(LineTool()),
                child: Text("Line"),
              ),
              ElevatedButton(
                onPressed: () => _switchTool(RectangleTool()),
                child: Text("Rectangle"),
              ),
              ElevatedButton(
                onPressed: () => _switchTool(CircleTool()),
                child: Text("Circle"),
              ),
            ],
          ),
        ),
        Positioned(
          top: 16,
          right: 16,
          child: Row(
            children: [
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: _toggleGrid,
                child: Text(_showGrid ? "Hide Grid" : "Show Grid"),
              ),
              ElevatedButton(
                onPressed: _clearCanvas,
                child: Text("Clear"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
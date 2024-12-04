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
import 'models/layer.dart';

class DrawingPainter extends CustomPainter {
  final List<Layer> layers;
  final List<Offset?> points;
  final List<Offset?>? previewPoints;
  final bool showGrid;
  final Color strokeColor;
  final double strokeWidth;
  final double gridSize;

  DrawingPainter(
    this.layers,
    this.points, {
    required this.previewPoints,
    this.showGrid = false,
    required this.strokeColor,
    required this.strokeWidth,
    required this.gridSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background
    final backgroundPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    // Draw grid first (beneath the shapes)
    if (showGrid) {
      final gridPaint = Paint()
        ..color = Colors.grey.withOpacity(0.3)
        ..strokeWidth = 0.5;

      for (double x = 0; x < size.width; x += gridSize) {
        canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
      }
      for (double y = 0; y < size.height; y += gridSize) {
        canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
      }
    }

    // Draw each layer's shapes
    for (Layer layer in layers) {
      if (!layer.isVisible) continue;

      for (DrawingShape shape in layer.shapes) {
        final fillPaint = Paint()
          ..color = shape.fillColor
          ..style = PaintingStyle.fill;

        final strokePaint = Paint()
          ..color = shape.strokeColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = shape.strokeWidth;

        canvas.drawPath(shape.path, fillPaint);
        canvas.drawPath(shape.path, strokePaint);
      }
    }

    // Draw preview points (always on top)
    if (previewPoints != null && previewPoints!.isNotEmpty) {
      final previewPaint = Paint()
        ..color = strokeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;

      for (int i = 0; i < previewPoints!.length - 1; i++) {
        if (previewPoints![i] != null && previewPoints![i + 1] != null) {
          canvas.drawLine(previewPoints![i]!, previewPoints![i + 1]!, previewPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) {
    return oldDelegate.layers != layers ||
        oldDelegate.points != points ||
        oldDelegate.previewPoints != previewPoints ||
        oldDelegate.showGrid != showGrid ||
        oldDelegate.strokeColor != strokeColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gridSize != gridSize;
  }
}

class DrawingCanvas extends StatefulWidget {
  final ValueNotifier<List<Layer>> layersNotifier;

  const DrawingCanvas({super.key, required this.layersNotifier});

  @override
  DrawingCanvasState createState() => DrawingCanvasState();
}

class DrawingCanvasState extends State<DrawingCanvas> {
  final GlobalKey exportGlobalKey = GlobalKey();
  final ValueNotifier<List<Offset?>> _pointsNotifier = ValueNotifier([]);
  final ValueNotifier<List<Offset?>> _previewPointsNotifier = ValueNotifier([]);

  Layer? _activeLayer;

  bool _showGrid = true;
  bool _snapToGrid = true;
  double _gridSize = 10.0;

  DrawingTool selectedTool = FreeformTool();
  Color _fillColor = Colors.transparent;
  Color _strokeColor = Colors.black;
  double _strokeWidth = 4.0;

  String getToolTypeForTool(selectedTool) {
    if (selectedTool is FreeformTool) return 'Freeform';
    if (selectedTool is LineTool) return 'Line';
    if (selectedTool is CircleTool) return 'Circle';
    if (selectedTool is RectangleTool) return 'Rectangle';
    if (selectedTool is TriangleTool) return 'Triangle';
    if (selectedTool is DeleteTool) return 'Delete';
    throw Exception('Unknown tool type');
  }

  @override
  void initState() {
    super.initState();
    widget.layersNotifier.addListener(_updateActiveLayer);
  }

  void _updateActiveLayer() {
    if (_activeLayer == null || !widget.layersNotifier.value.contains(_activeLayer)) {
      setActiveLayer(widget.layersNotifier.value.isNotEmpty ? widget.layersNotifier.value.first : null);
    }
    setState(() {}); // Trigger UI update
  }

  void setActiveLayer(Layer? layer) {
    setState(() {
      _activeLayer = layer;
    });
  }

  void updateGridSize(double gridSize) {
    setState(() {
      _gridSize = gridSize;
    });
  }

  void updateColors(Color fillColor, Color strokeColor) {
    setState(() {
      _fillColor = fillColor;
      _strokeColor = strokeColor;
    });
  }

  void updateStrokeWidth(double strokeWidth) {
    setState(() {
      _strokeWidth = strokeWidth;
    });
  }

  void switchTool(DrawingTool tool) {
    setState(() {
      selectedTool = tool;
      selectedTool.setSnapToGrid(_snapToGrid);
    });
  }

  void clearCanvas() {
    setState(() {
      for (var layer in widget.layersNotifier.value) {
        layer.shapes.clear();
      }
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

  Offset _calculateSnapToGrid(Offset position) {
    if (!_snapToGrid || !selectedTool.shouldSnapToGrid()) return position;
    double snappedX = (position.dx / _gridSize).round() * _gridSize;
    double snappedY = (position.dy / _gridSize).round() * _gridSize;
    return Offset(snappedX, snappedY);
  }

  void _addShape(DrawingShape shape) {
    if (_activeLayer == null) return;

    setState(() {
      shape = DrawingShape(
        points: shape.points,
        toolType: shape.toolType,
        fillColor: shape.toolType == 'Freeform' || shape.toolType == 'Line'
            ? Colors.transparent
            : _fillColor,
        strokeColor: _strokeColor,
        strokeWidth: _strokeWidth,
      );
      _activeLayer!.shapes.add(shape);
      widget.layersNotifier.value = List.from(widget.layersNotifier.value);
    });
  }

  void export() {
    exportToPdf(context, exportGlobalKey);
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: exportGlobalKey,
      child: ValueListenableBuilder<List<Layer>>(
        valueListenable: widget.layersNotifier,
        builder: (context, layers, _) {
          return Stack(
            children: [
              GestureDetector(
                onPanStart: (details) {
                  selectedTool.onPanStart(
                    _calculateSnapToGrid(details.localPosition),
                    _previewPointsNotifier.value,
                  );
                  _previewPointsNotifier.value =
                      List.from(_previewPointsNotifier.value);
                },
                onPanUpdate: (details) {
                  selectedTool.onPanUpdate(
                    _calculateSnapToGrid(details.localPosition),
                    _previewPointsNotifier.value,
                  );
                  _previewPointsNotifier.value =
                      List.from(_previewPointsNotifier.value);
                },
                onPanEnd: (details) {
                  selectedTool.onPanEnd(
                    _calculateSnapToGrid(details.localPosition),
                    _previewPointsNotifier.value,
                  );
                  if (_previewPointsNotifier.value.isNotEmpty) {
                    _addShape(DrawingShape(
                      points: List.from(_previewPointsNotifier.value),
                      toolType: getToolTypeForTool(selectedTool),
                      fillColor: _fillColor,
                      strokeColor: _strokeColor,
                      strokeWidth: _strokeWidth,
                    ));
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
                          child: CustomPaint(
                            painter: DrawingPainter(
                              layers,
                              points,
                              previewPoints: previewPoints,
                              showGrid: _showGrid,
                              strokeColor: _strokeColor,
                              strokeWidth: _strokeWidth,
                              gridSize: _gridSize,
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
          );
        },
      ),
    );
  }
}
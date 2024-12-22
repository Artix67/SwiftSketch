import 'package:flutter/material.dart';
import '/export_drawing.dart';
import '/drawing_tools/drawing_tool.dart';
import '/drawing_tools/freeform_tool.dart';
import '/drawing_tools/line_tool.dart';
import '/drawing_tools/rectangle_tool.dart';
import '/drawing_tools/circle_tool.dart';
import '/drawing_tools/triangle_tool.dart';
import '/drawing_tools/delete_tool.dart';
import '/drawing_tools/annotation_tool.dart';
import '/drawing_shapes/drawing_shape.dart';
import 'models/layer.dart';
import '/drawing_tools/undo_redo_manager.dart';

class DrawingPainter extends CustomPainter {
  final List<Layer> layers;
  final List<Offset?> points;
  final List<Offset?>? previewPoints;
  final bool showGrid;
  final Color strokeColor;
  final double strokeWidth;
  final double gridSize;
  final int undoCalled;

  DrawingPainter(
      this.layers,
      this.points, {
        required this.previewPoints,
        this.showGrid = false,
        required this.strokeColor,
        required this.strokeWidth,
        required this.gridSize,
        required this.undoCalled,
      });

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

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

        if (shape.toolType == 'Annotation' && shape.annotation != null) {
          final bounds = shape.path.getBounds();
          const double padding = 8.0;

          final backgroundPaint = Paint()
            ..color = Colors.white
            ..style = PaintingStyle.fill;
          canvas.drawRect(bounds.inflate(padding), backgroundPaint);

          final borderPaint = Paint()
            ..color = Colors.black
            ..style = PaintingStyle.stroke
            ..strokeWidth = 4.0;
          canvas.drawRect(bounds.inflate(1), borderPaint);

          final textSpan = TextSpan(
            text: shape.annotation,
            style: const TextStyle(color: Colors.black),
          );

          final textPainter = TextPainter(
            text: textSpan,
            textDirection: TextDirection.ltr,
          );

          double fontSize = 100.0;
          const double minFontSize = 12.0;
          const double paddingReduction = padding * 2;

          while (fontSize > minFontSize) {
            textPainter.text = TextSpan(
              text: shape.annotation,
              style: TextStyle(color: Colors.black, fontSize: fontSize),
            );

            textPainter.layout(maxWidth: bounds.width - paddingReduction);

            if (textPainter.size.height <= bounds.height - paddingReduction) {
              break;
            }
            fontSize -= 1.0;
          }

          textPainter.layout(maxWidth: bounds.width - paddingReduction);

          final offset = Offset(
            bounds.left + (bounds.width - textPainter.width) / 2,
            bounds.top + (bounds.height - textPainter.height) / 2,
          );

          textPainter.paint(canvas, offset);
        }

        canvas.drawPath(shape.path, fillPaint);
        canvas.drawPath(shape.path, strokePaint);
      }
    }

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

    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Undo Count: $undoCalled',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, const Offset(10, 10));

  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) {
    return oldDelegate.layers != layers ||
        oldDelegate.points != points ||
        oldDelegate.previewPoints != previewPoints ||
        oldDelegate.showGrid != showGrid ||
        oldDelegate.strokeColor != strokeColor ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.gridSize != gridSize ||
        oldDelegate.undoCalled != undoCalled;
  }
}

class DrawingCanvas extends StatefulWidget {
  final ValueNotifier<List<Layer>> layersNotifier;
  final double initialSnapSensitivity;

  const DrawingCanvas({
    super.key,
    required this.layersNotifier,
    required this.initialSnapSensitivity,
  });

  @override
  DrawingCanvasState createState() => DrawingCanvasState();
}

class DrawingCanvasState extends State<DrawingCanvas> {
  final GlobalKey exportGlobalKey = GlobalKey();
  final ValueNotifier<List<Offset?>> _pointsNotifier = ValueNotifier<List<Offset?>>([]);
  final ValueNotifier<List<Offset?>> _previewPointsNotifier = ValueNotifier<List<Offset?>>([]);
  // final TransformationController _transformationController = TransformationController(); // Daniel - Transformation Controller added
  final ValueNotifier<bool> isZoomEnabledNotifier = ValueNotifier(false);

  int undoCalled = 0;

  Layer? _activeLayer;

  bool _showGrid = true;
  bool _snapToGrid = true;
  bool _isZoomEnabled = false; // Daniel - New variable to manage zoom state
  double _gridSize = 10.0;
  late double _snapSensitivity;

  DrawingTool selectedTool = FreeformTool();
  List<DrawingShape> shapes = [];
  final UndoRedoManager _undoRedoManager = UndoRedoManager(); // Undo/Redo manager initialization
  Color _fillColor = Colors.transparent;
  Color _strokeColor = Colors.black;
  double _strokeWidth = 4.0;

  bool get isZoomEnabled => _isZoomEnabled;

  String getToolTypeForTool(selectedTool) {
    if (selectedTool is FreeformTool) return 'Freeform';
    if (selectedTool is LineTool) return 'Line';
    if (selectedTool is CircleTool) return 'Circle';
    if (selectedTool is RectangleTool) return 'Rectangle';
    if (selectedTool is TriangleTool) return 'Triangle';
    if (selectedTool is AnnotationTool) return 'Note';
    if (selectedTool is DeleteTool) return 'Delete';
    throw Exception('Unknown tool type');
  }

  Offset snapToGridOrExistingPoint(
      Offset position, List<Offset> snapPoints, double gridSize, double snapSensitivity) {
    if (!_snapToGrid) {
      return position;
    }

    double snapRadius = gridSize * snapSensitivity;

    for (final snapPoint in snapPoints) {
      if ((position - snapPoint).distance <= snapRadius) {
        return snapPoint;
      }
    }

    double snappedX = (position.dx / gridSize).round() * gridSize;
    double snappedY = (position.dy / gridSize).round() * gridSize;
    return Offset(snappedX, snappedY);
  }

  List<Offset> getSnapPoints(List<Layer> layers) {
    final snapPoints = <Offset>[];
    for (final layer in layers) {
      for (final shape in layer.shapes) {
        snapPoints.addAll(shape.points.whereType<Offset>());
      }
    }
    return snapPoints;
  }

  @override
  void initState() {
    super.initState();
    _snapSensitivity = widget.initialSnapSensitivity;
    _undoRedoManager.addAction(widget.layersNotifier.value);
    _undoRedoManager.addAction(widget.layersNotifier.value);
    widget.layersNotifier.addListener(_updateActiveLayer);
  }

  void _updateActiveLayer() {
    if (_activeLayer == null ||
        !widget.layersNotifier.value.contains(_activeLayer)) {
      setActiveLayer(
          widget.layersNotifier.value.isNotEmpty ? widget.layersNotifier.value
              .first : null);
    }
    setState(() {});
  }

  void setActiveLayer(Layer? layer) {
    setState(() {
      _activeLayer = layer;
    });
  }

  void updateSnapSensitivity(double value) {
    setState(() {
      _snapSensitivity = value;
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

  void undo() {
    widget.layersNotifier.value = _undoRedoManager.undo(widget.layersNotifier.value);
    undoCalled += 1;
  }

  void redo() {
    widget.layersNotifier.value = _undoRedoManager.redo();
    undoCalled += 1;
  }

  void clearCanvas() {
    setState(() {
      if (widget.layersNotifier.value.isNotEmpty) {
        widget.layersNotifier.value[0].shapes.clear();
        widget.layersNotifier.value = [widget.layersNotifier.value[0]];
      } else {
        widget.layersNotifier.value = [
          Layer(id: "1", name: "Layer 1", shapes: [], isVisible: true)
        ];
      }

      _pointsNotifier.value = [];
      _previewPointsNotifier.value = [];
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

  void onPanStartHandler(Offset position) {
    final snapPoints = getSnapPoints(widget.layersNotifier.value);
    if (selectedTool is FreeformTool) {
      selectedTool.onPanStart(position, _previewPointsNotifier.value);
    } else {
      selectedTool.onPanStart(
        snapToGridOrExistingPoint(
            position, snapPoints, _gridSize, _snapSensitivity),
        _previewPointsNotifier.value,
      );
    }
  }

  void onPanUpdateHandler(Offset position) {
    final snapPoints = getSnapPoints(widget.layersNotifier.value);
    if (selectedTool is FreeformTool) {
      selectedTool.onPanUpdate(position, _previewPointsNotifier.value);
    } else {
      selectedTool.onPanUpdate(
        snapToGridOrExistingPoint(
            position, snapPoints, _gridSize, _snapSensitivity),
        _previewPointsNotifier.value,
      );
    }
  }

  void onPanEndHandler(Offset position) {
    final snapPoints = getSnapPoints(widget.layersNotifier.value);
    if (selectedTool is FreeformTool) {
      selectedTool.onPanEnd(position, _previewPointsNotifier.value);
    } else {
      selectedTool.onPanEnd(
        snapToGridOrExistingPoint(
            position, snapPoints, _gridSize, _snapSensitivity),
        _previewPointsNotifier.value,
      );
    }

    if (_previewPointsNotifier.value.isNotEmpty) {
      _addShape(DrawingShape(
        points: List.from(_previewPointsNotifier.value),
        toolType: getToolTypeForTool(selectedTool),
        fillColor: _fillColor,
        strokeColor: _strokeColor,
        strokeWidth: _strokeWidth,
        tool: selectedTool,
      ));
    }

    _previewPointsNotifier.value = [];
  }

  void _addShape(DrawingShape shape) {
    if (_activeLayer == null) return;

    setState(() {
      if (selectedTool is AnnotationTool) {
        showDialog(
          context: context,
          builder: (context) {
            TextEditingController annotationController = TextEditingController();
            return AlertDialog(
              title: const Text("Add Annotation"),
              content: TextField(
                controller: annotationController,
                decoration: const InputDecoration(hintText: "Enter your note"),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (annotationController.text.isNotEmpty) {
                      shape = DrawingShape(
                        points: shape.points,
                        toolType: 'Annotation',
                        fillColor: Colors.transparent,
                        strokeColor: _strokeColor,
                        strokeWidth: _strokeWidth,
                        annotation: annotationController.text,
                        tool: selectedTool,
                      );
                      _activeLayer!.shapes.add(shape);
                      widget.layersNotifier.value =
                          List.from(widget.layersNotifier.value);
                      _undoRedoManager.addAction(widget.layersNotifier.value);
                      undoCalled += 1;
                    }
                  },
                  child: const Text("Save"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancel"),
                ),
              ],
            );
          },
        );
      } else {
        shape = DrawingShape(
          points: shape.points,
          toolType: shape.toolType,
          fillColor: shape.toolType == 'Freeform' || shape.toolType == 'Line'
              ? Colors.transparent
              : _fillColor,
          strokeColor: _strokeColor,
          strokeWidth: _strokeWidth,
          tool: selectedTool,
        );
        _activeLayer!.shapes.add(shape);
        widget.layersNotifier.value = List.from(widget.layersNotifier.value);
        _undoRedoManager.addAction(widget.layersNotifier.value);
        undoCalled += 1;
      }
    });
  }

  void toggleZoom() {
    setState(() {
      _isZoomEnabled = !_isZoomEnabled;
      isZoomEnabledNotifier.value = _isZoomEnabled;
      // Taylor - I commented this out cause you couldn't zoom in, turn zoom off,
      // then draw while zoomed. Not sure why this was put here.

      /* if (!_isZoomEnabled) {
         _transformationController.value = Matrix4.identity();
       } */
    });
  }

  @override
  void dispose() {
    isZoomEnabledNotifier.dispose();
    super.dispose();
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
                  onPanStartHandler(details.localPosition);
                  _previewPointsNotifier.value =
                      List.from(_previewPointsNotifier.value);
                },
                onPanUpdate: (details) {
                  onPanUpdateHandler(details.localPosition);
                  _previewPointsNotifier.value =
                      List.from(_previewPointsNotifier.value);
                },
                onPanEnd: (details) {
                  onPanEndHandler(details.localPosition);
                  if (getToolTypeForTool(selectedTool) == "Delete") {
                    _undoRedoManager.addAction(widget.layersNotifier.value);
                    undoCalled += 1;
                  }
                  if (_previewPointsNotifier.value.isNotEmpty) {
                    _addShape(DrawingShape(
                      points: List.from(_previewPointsNotifier.value),
                      toolType: getToolTypeForTool(selectedTool),
                      fillColor: _fillColor,
                      strokeColor: _strokeColor,
                      strokeWidth: _strokeWidth,
                      tool: selectedTool,
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
                              undoCalled: undoCalled,
                            ),
                            size: Size.infinite,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              // Positioned widget to display the Undo count
              Positioned(
                top: 10.0,
                left: 10.0,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    'Undo Count: $undoCalled',
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
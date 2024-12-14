import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import '../drawing_canvas.dart';
import '../drawing_shapes/drawing_shape.dart';
import '../drawing_tools/freeform_tool.dart';
import '../drawing_tools/circle_tool.dart';
import '../drawing_tools/delete_tool.dart';
import '../drawing_tools/line_tool.dart';
import '../drawing_tools/rectangle_tool.dart';
import '../drawing_tools/triangle_tool.dart';
import '../drawing_tools/annotation_tool.dart';
import 'homescreen.dart';

class Toolbar extends StatelessWidget {
  final Color fillColor;
  final Color strokeColor;
  final double strokeWidth;
  final double gridSize;
  final double snapSensitivity;
  final Function(double) onUpdateStrokeWidth;
  final Function(double) onUpdateGridSize;
  final Function(Color, Color) onUpdateColors;
  final Function(double) onUpdateSnapSensitivity;
  final GlobalKey<DrawingCanvasState> drawingCanvasKey;
  final VoidCallback onDeleteToolUpdate;
  final List<DrawingShape> activeLayerShapes;
  final VoidCallback refreshUI;

  const Toolbar({
    super.key,
    required this.fillColor,
    required this.strokeColor,
    required this.strokeWidth,
    required this.gridSize,
    required this.snapSensitivity,
    required this.onUpdateStrokeWidth,
    required this.onUpdateGridSize,
    required this.onUpdateColors,
    required this.onUpdateSnapSensitivity,
    required this.drawingCanvasKey,
    required this.onDeleteToolUpdate,
    required this.activeLayerShapes,
    required this.refreshUI,
  });

  void _pickColor(BuildContext context, bool isFill) {
    Color tempColor = isFill ? fillColor : strokeColor;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isFill ? 'Pick Fill Color' : 'Pick Stroke Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              color: tempColor,
              onColorChanged: (Color color) {
                if (isFill) {
                  onUpdateColors(color, strokeColor);
                } else {
                  onUpdateColors(fillColor, color);
                }
              },
              showColorName: true,
              enableShadesSelection: true,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.orange[100],
      actions: <Widget>[
        Slider(
          value: snapSensitivity,
          min: 1.0,
          max: 5.0,
          divisions: 4,
          label: '${snapSensitivity.toStringAsFixed(1)}x',
          onChanged: (value) {
            onUpdateSnapSensitivity(value);
          },
        ),
        Slider(
          value: gridSize,
          min: 5.0,
          max: 50.0,
          divisions: 9,
          label: '${gridSize.toInt()} px',
          onChanged: onUpdateGridSize,
        ),
        Slider(
          value: strokeWidth,
          min: 1.0,
          max: 10.0,
          divisions: 9,
          label: '${strokeWidth.toStringAsFixed(1)} px',
          onChanged: onUpdateStrokeWidth,
        ),
        IconButton(
          icon: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.square_rounded,
                color:
                    fillColor == Colors.transparent ? Colors.grey : fillColor,
              ),
              if (fillColor == Colors.transparent)
                const Icon(
                  //indicates no fill color, otherwise icon would be invisible
                  Icons.blur_off_outlined,
                  color: Colors.redAccent,
                  size: 16,
                ),
            ],
          ),
          tooltip: 'Set Fill Color',
          onPressed: () {
            _pickColor(context, true);
          },
        ),
        IconButton(
          icon: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.crop_square_rounded,
                color: strokeColor == Colors.transparent
                    ? Colors.grey
                    : strokeColor,
              ),
              if (strokeColor == Colors.transparent)
                const Icon(
                  //indicates no stroke color, otherwise icon would be invisible
                  Icons.blur_off_outlined,
                  color: Colors.redAccent,
                  size: 16,
                ),
            ],
          ),
          tooltip: 'Set Stroke Color',
          onPressed: () {
            _pickColor(context, false);
          },
        ),
        IconButton(
          icon: const Icon(Icons.edit),
          tooltip: 'Freeform',
          onPressed: () {
            drawingCanvasKey.currentState?.switchTool(FreeformTool());
          },
        ),
        IconButton(
          icon: const Icon(Icons.horizontal_rule),
          tooltip: 'Line',
          onPressed: () {
            drawingCanvasKey.currentState?.switchTool(LineTool());
          },
        ),
        IconButton(
          icon: const Icon(Icons.signal_cellular_0_bar),
          tooltip: 'Triangle',
          onPressed: () {
            drawingCanvasKey.currentState?.switchTool(TriangleTool());
          },
        ),
        IconButton(
          icon: const Icon(Icons.square_outlined),
          tooltip: 'Rectangle',
          onPressed: () {
            drawingCanvasKey.currentState?.switchTool(RectangleTool());
          },
        ),
        IconButton(
          icon: const Icon(Icons.circle_outlined),
          tooltip: 'Circle',
          onPressed: () {
            drawingCanvasKey.currentState?.switchTool(CircleTool());
          },
        ),
        IconButton(
          icon: const Icon(Icons.note),
          tooltip: 'Annotation Tool',
          onPressed: () {
            drawingCanvasKey.currentState?.switchTool(AnnotationTool());
          },
        ),
        IconButton(
          icon: const Icon(Icons.cancel_rounded),
          tooltip: 'Delete',
          onPressed: () {
            drawingCanvasKey.currentState?.switchTool(DeleteTool(
              activeLayerShapes,
                  () {
                refreshUI();
              },
            ));
          },
        ),
        IconButton(
          icon: const Icon(Icons.grid_on),
          tooltip: 'Toggle Grid',
          onPressed: () {
            drawingCanvasKey.currentState?.toggleGrid();
          },
        ),
        IconButton(
          icon: const Icon(Icons.square_foot),
          tooltip: 'Snap to Grid',
          onPressed: () {
            drawingCanvasKey.currentState?.toggleSnapToGrid();
          },
        ),
        IconButton(
          icon: const Icon(Icons.clear),
          tooltip: 'Clear Canvas',
          onPressed: () async {
            final shouldClear = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Reset Drawing and Layers'),
                content: const Text(
                  'Are you sure you want to reset the drawing and all layers? This action cannot be undone.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Reset'),
                  ),
                ],
              ),
            );

            if (shouldClear == true) {
              drawingCanvasKey.currentState?.clearCanvas();
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.ios_share),
          tooltip: 'Export',
          onPressed: () {
            drawingCanvasKey.currentState?.export();
          },
        ),
        IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const HomeScreen();
            }));
          },
          icon: const Icon(Icons.keyboard_return),
        ),
      ],
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:swift_sketch/drawing_tools/triangle_tool.dart';
import 'package:swift_sketch/screens/homescreen.dart';
import '/drawing_tools/freeform_tool.dart';
import '/drawing_tools/line_tool.dart';
import '/drawing_tools/circle_tool.dart';
import '/drawing_tools/delete_tool.dart';
import '/drawing_tools/rectangle_tool.dart';
import '../drawing_canvas.dart';

class Drawscreen extends StatefulWidget{
  const Drawscreen({super.key});

  @override
  State<Drawscreen> createState() => _Drawscreen();
}

class _Drawscreen extends State<Drawscreen>{
  final GlobalKey<DrawingCanvasState> _drawingCanvasKey = GlobalKey<DrawingCanvasState>();

  Color _fillColor = Colors.transparent;
  Color _strokeColor = Colors.black;
  double _strokeWidth = 4.0;
  double _gridSize = 10.0;

  void _updateStrokeWidth(double value) {
    setState(() {
      _strokeWidth = value;
    });
    _drawingCanvasKey.currentState?.updateStrokeWidth(value);
  }

  void _updateGridSize(double value) {
    setState(() {
      _gridSize = value;
    });
    _drawingCanvasKey.currentState?.updateGridSize(value);
  }

  void _pickColor(BuildContext context, bool isFill) {
    Color tempColor = isFill ? _fillColor : _strokeColor;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isFill ? 'Pick Fill Color' : 'Pick Stroke Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              color: tempColor,
              onColorChanged: (Color color) {
                setState(() {
                  if (isFill) {
                    _fillColor = color;
                  } else {
                    _strokeColor = color;
                  }
                  _drawingCanvasKey.currentState?.updateColors(_fillColor, _strokeColor);
                });
              },
              showColorName: true,
              enableShadesSelection: true,
              pickersEnabled: const <ColorPickerType, bool>{
                ColorPickerType.both: true,
                ColorPickerType.primary: true,
                ColorPickerType.accent: false,
              },
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
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orange[100],
            actions: <Widget>[
              Slider(
                value: _gridSize,
                min: 5.0,
                max: 50.0,
                divisions: 9,
                label: '${_gridSize.toInt()} px',
                onChanged: (value) {
                  _updateGridSize(value);
                },
              ),
              Slider(
                value: _strokeWidth,
                min: 1.0,
                max: 10.0,
                divisions: 9,
                label: '${_strokeWidth.toStringAsFixed(1)} px',
                onChanged: (value) {
                  _updateStrokeWidth(value);
                },
              ),
              IconButton(
                icon: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.square_rounded,
                      color: _fillColor == Colors.transparent ? Colors.grey : _fillColor,
                    ),
                    if (_fillColor == Colors.transparent)
                      Icon( //indicates no fill color, otherwise icon would be invisible
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
                      color: _strokeColor == Colors.transparent ? Colors.grey : _strokeColor,
                    ),
                    if (_strokeColor == Colors.transparent)
                      Icon( //indicates no stroke color, otherwise icon would be invisible
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
                  _drawingCanvasKey.currentState?.switchTool(FreeformTool());
                },
              ),
              IconButton(
                icon: const Icon(Icons.horizontal_rule),
                tooltip: 'Line',
                onPressed: () {
                  _drawingCanvasKey.currentState?.switchTool(LineTool());
                },
              ),
              IconButton(
                icon: const Icon(Icons.signal_cellular_0_bar),
                tooltip: 'Triangle',
                onPressed: () {
                  _drawingCanvasKey.currentState?.switchTool(TriangleTool());
                },
              ),
              IconButton(
                icon: const Icon(Icons.square_outlined),
                tooltip: 'Rectangle',
                onPressed: () {
                  _drawingCanvasKey.currentState?.switchTool(RectangleTool());
                },
              ),
              IconButton(
                icon: const Icon(Icons.circle_outlined),
                tooltip: 'Circle',
                onPressed: () {
                  _drawingCanvasKey.currentState?.switchTool(CircleTool());
                },
              ),
              IconButton(
                icon: const Icon(Icons.cancel_rounded),
                tooltip: 'Delete',
                onPressed: () {
                  _drawingCanvasKey.currentState?.switchTool(DeleteTool(
                    _drawingCanvasKey.currentState?.shapes ?? [],
                        () {
                      setState(() {}); // Refresh UI
                    },
                  ));
                },
              ),
              IconButton(
                icon: const Icon(Icons.grid_on),
                tooltip: 'Toggle Grid',
                onPressed: () {
                  _drawingCanvasKey.currentState?.toggleGrid();
                },
              ),
              IconButton(
                icon: const Icon(Icons.square_foot),
                tooltip: 'Snap to Grid',
                onPressed: () {
                  _drawingCanvasKey.currentState?.toggleSnapToGrid();
                },
              ),
              IconButton(
                icon: const Icon(Icons.clear),
                tooltip: 'Clear Canvas',
                onPressed: () {
                  _drawingCanvasKey.currentState?.clearCanvas();
                },
              ),
              IconButton(
                icon: const Icon(Icons.ios_share),
                tooltip: 'Export',
                onPressed: () {
                  _drawingCanvasKey.currentState?.export();
                },
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context){
                        return const HomeScreen();
                      })
                  );
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
          body: DrawingCanvas(key: _drawingCanvasKey),
        )
    );
  }
}



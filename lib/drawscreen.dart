
import 'package:flutter/material.dart';
import 'package:swift_sketch/drawing_tools/triangle_tool.dart';
import 'package:swift_sketch/homescreen.dart';
import '/drawing_tools/freeform_tool.dart';
import '/drawing_tools/line_tool.dart';
import '/drawing_tools/circle_tool.dart';
import '/drawing_tools/delete_tool.dart';
import '/drawing_tools/rectangle_tool.dart';
import 'drawing_canvas.dart';

class Drawscreen extends StatefulWidget{
  const Drawscreen({super.key});

  @override
  State<Drawscreen> createState() => _Drawscreen();
}

class _Drawscreen extends State<Drawscreen>{
  // final GlobalKey globalKey = GlobalKey();
  final GlobalKey<DrawingCanvasState> _drawingCanvasKey = GlobalKey<DrawingCanvasState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orange[100],
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Freeform',
                onPressed: () {
                  _drawingCanvasKey.currentState?.switchTool(FreeformTool());
                },
              ),
              IconButton(
                icon: const Icon(Icons.zoom_in),
                tooltip: 'Toggle Zoom',
                onPressed: () {
                  _drawingCanvasKey.currentState?.toggleZoom();
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



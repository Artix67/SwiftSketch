
import 'package:flutter/material.dart';
import 'package:swift_sketch/drawing_canvas.dart';
import 'package:swift_sketch/homescreen.dart';
import '/drawing_tools/freeform_tool.dart';
import '/drawing_tools/line_tool.dart';
import '/drawing_tools/circle_tool.dart';
import '/drawing_tools/delete_tool.dart';
import '/drawing_tools/rectangle_tool.dart';

class Drawscreen extends StatefulWidget{
  const Drawscreen({super.key});

  @override
  State<Drawscreen> createState() => _Drawscreen();
}

class _Drawscreen extends State<Drawscreen>{
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
                icon: const Icon(Icons.horizontal_rule),
                tooltip: 'Line',
                onPressed: () {
                  _drawingCanvasKey.currentState?.switchTool(LineTool());
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
                icon: const Icon(Icons.vertical_align_center),
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



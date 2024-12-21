
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
              Transform.scale(
                scale: 2,
                child:  IconButton(onPressed: () {},
                    icon: const ImageIcon(AssetImage("icons/save.png"))
                ),
              ),
              const SizedBox(width: 15,),
              Transform.scale(
                scale: 2,
                child: IconButton(
                  icon: const ImageIcon(AssetImage("icons/export2.png")),
                  tooltip: 'Export',
                  onPressed: () {
                    _drawingCanvasKey.currentState?.export();
                  },
                ),
              ),
              const SizedBox(width: 15,),
              Transform.scale(
                scale: 2,
                child: IconButton(onPressed: (){},
                    icon: const ImageIcon(AssetImage("icons/undo.png"))
                ),
              ),
              const SizedBox(width: 15,),
              Transform.scale(
                scale: 2,
                child: IconButton(onPressed: (){},
                    icon: const ImageIcon(AssetImage("icons/redo.png"))
                )
              ),
              const SizedBox(width: 15,),
              Transform.scale(
                scale: 2,
                child: IconButton(onPressed: (){},
                    icon: const ImageIcon(AssetImage("icons/slidermenu.png"))
                ),
              ),
              const SizedBox(width: 15,),
              Transform.scale(
                scale: 2,
                child:  IconButton(
                  icon: const ImageIcon(AssetImage("icons/draw.png")),
                  tooltip: 'Freeform',
                  onPressed: () {
                    _drawingCanvasKey.currentState?.switchTool(FreeformTool());
                  },
                ),
              ),
              const SizedBox(width: 15,),
              Transform.scale(
                scale: 2,
                child: IconButton(
                  icon:  const ImageIcon(AssetImage("icons/line.png")),
                  tooltip: 'Line',
                  onPressed: () {
                    _drawingCanvasKey.currentState?.switchTool(LineTool());
                  },
                ),
              ),
              const SizedBox(width: 15,),
              Transform.scale(
                scale: 2,
                child: IconButton(
                  icon: const ImageIcon(AssetImage("icons/square.png")),
                  tooltip: 'Rectangle',
                  onPressed: () {
                    _drawingCanvasKey.currentState?.switchTool(RectangleTool());
                  },
                ),
              ),
              const SizedBox(width: 15,),
              Transform.scale(
                scale: 2,
                child:  IconButton(
                  icon: const ImageIcon(AssetImage("icons/triangle.png")),
                  tooltip: 'Triangle',
                  onPressed: () {
                    _drawingCanvasKey.currentState?.switchTool(TriangleTool());
                  },
                ),
              ),
              const SizedBox(width: 15,),
              Transform.scale(
                scale: 2,
                child: IconButton(
                  icon: const ImageIcon(AssetImage("icons/circle.png")),
                  tooltip: 'Circle',
                  onPressed: () {
                    _drawingCanvasKey.currentState?.switchTool(CircleTool());
                  },
                ),
              ),
              const SizedBox(width: 15,),
              Transform.scale(
                scale: 2,
                child:  IconButton(onPressed: (){},
                    icon:  const ImageIcon(AssetImage("icons/freeformshapes.png"))
                ),
              ),
              const SizedBox(width: 15,),
              Transform.scale(
                scale: 2,
                child:  IconButton(onPressed: (){},
                    icon:  const ImageIcon(AssetImage("icons/label.png"))
                ),
              ),
              const SizedBox(width: 15,),
              Transform.scale(
                scale: 2,
                child: IconButton(
                  icon: const ImageIcon(AssetImage("icons/eraser.png")),
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
              ),
              const SizedBox(width: 15,),
              Transform.scale(
                scale: 2,
                child: IconButton(onPressed: (){},
                    icon:  const ImageIcon(AssetImage("icons/zoomin.png"))
                ),
              ),
              const SizedBox(width: 15,),
              Transform.scale(
                scale: 2,
                child: IconButton(onPressed: (){},
                    icon:  const ImageIcon(AssetImage("icons/pan.png"))
                ),
              ),
              const SizedBox(width: 15,),
              Transform.scale(
                scale: 2,
                child: IconButton(onPressed: (){},
                    icon:  const ImageIcon(AssetImage("icons/cursor.png"))
                ),
              ),
              const SizedBox(width: 15,),
              Transform.scale(
                scale: 2,
                child: IconButton(
                  icon: const ImageIcon(AssetImage("icons/grid.png")),
                  tooltip: 'Toggle Grid',
                  onPressed: () {
                    _drawingCanvasKey.currentState?.toggleGrid();
                  },
                ),
              ),
              const SizedBox(width: 15,),
              Transform.scale(
                scale: 2,
                child:  IconButton(
                  icon: const Icon(Icons.square_foot),
                  tooltip: 'Snap to Grid',
                  onPressed: () {
                    _drawingCanvasKey.currentState?.toggleSnapToGrid();
                  },
                ),
              ),
              const SizedBox(width: 15,),
              Transform.scale(
                scale: 2,
                child: IconButton(
                  icon:const Icon(Icons.delete),
                  tooltip: 'Clear Canvas',
                  onPressed: () {
                    _drawingCanvasKey.currentState?.clearCanvas();
                  },
                ),
              ),
              const SizedBox(width: 15,),
              Transform.scale(
                scale: 2,
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context){
                          return const HomeScreen();
                        })
                    );
                  },
                  icon:  const ImageIcon(AssetImage("icons/clear.png")),
                ),
              ),
              const SizedBox(width: 15,),
            ],
          ),
          body: DrawingCanvas(key: _drawingCanvasKey),
        )
    );
  }
}



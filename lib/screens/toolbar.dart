import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import '../drawing_canvas.dart';
import '../drawing_shapes/drawing_shape.dart';
import '../drawing_tools/drawing_tool.dart';
import '../drawing_tools/freeform_tool.dart';
import '../drawing_tools/circle_tool.dart';
import '../drawing_tools/delete_tool.dart';
import '../drawing_tools/line_tool.dart';
import '../drawing_tools/rectangle_tool.dart';
import '../drawing_tools/triangle_tool.dart';
import '../drawing_tools/annotation_tool.dart';
import 'homescreen.dart';
import 'loginscreen.dart';

const Color dgreencolor = Color(0xFF181C14);
const Color lgreencolor = Color(0xFF697565);
const Color biegecolor = Color(0xFFCBC2B4);
const Color redcolor = Color(0xFFAB3E2B);
const Color bluecolor = Color(0xFF11487A);
const Color blackcolor = Color(0xFF181818);
const Color midgreencolor = Color(0xFF3C3D37);
const Color whitecolor = Color(0xFFEEEEEE);

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
  final VoidCallback onSaved;
  final List<DrawingShape> activeLayerShapes;
  final VoidCallback refreshUI;
  final double spacerSize;
  final double iconSize;
  final String name;
  final bool isGuest;

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
    required this.onSaved,
    required this.activeLayerShapes,
    required this.refreshUI,
    required this.spacerSize,
    required this.iconSize,
    required this.name,
    required this.isGuest,
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

  void _showStrokeWidthDialog(BuildContext context) {
    // Take the current stroke width as a "starting" point
    double tempStrokeWidth = drawingCanvasKey.currentState!.strokeWidth;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Adjust Stroke Width"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 30),
                  StrokeWidth(
                    strokeWidth: tempStrokeWidth,
                    onUpdateStrokeWidth: (value) {
                      setStateDialog(() {
                        tempStrokeWidth = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(), // Cancel
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    // On OK, finally update the canvas stroke width
                    drawingCanvasKey.currentState!.updateStrokeWidth(tempStrokeWidth);
                    Navigator.of(context).pop();
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget buildToolButton({
    required DrawingTool tool,
    required String tooltip,
    required Widget icon,
    required VoidCallback onPressed,
  }) {
    return ValueListenableBuilder<DrawingTool>(
      valueListenable: drawingCanvasKey.currentState!.selectedToolNotifier,
      builder: (context, selectedTool, child) {
        final isSelected = selectedTool.runtimeType == tool.runtimeType;
        return Transform.scale(
          scale: iconSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (isSelected)
                Container(
                  width: 38,
                  height: 43,
                  decoration: BoxDecoration(
                    color: midgreencolor.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              IconButton(
                icon: icon,
                tooltip: tooltip,
                onPressed: onPressed,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(backgroundColor: biegecolor, actions: <Widget>[
      Expanded(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Transform.scale(
                scale: iconSize,
                child: IconButton(
                  onPressed: () async {
                    if (!isGuest) {
                      final shouldSave = await showDialog<bool>(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Save Drawing"),
                            content: const Text(
                              "Do you want to save your current drawing before returning to the home screen?",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false), // Don't Save
                                child: const Text("Don't Save"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true), // Save
                                child: const Text("Save"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(null), // Cancel
                                child: const Text("Cancel"),
                              ),
                            ],
                          );
                        },
                      );

                      // Handle user's choice
                      if (shouldSave == true) {
                        onSaved(); // Call the save function
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return const HomeScreen();
                        }));
                      } else if (shouldSave == false) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return const HomeScreen();
                        }));
                      }
                      // If shouldSave is null (Cancel), do nothing
                    } else {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return const LoginScreen();
                      }));
                    }
                  },
                  icon: Column(
                    children: [
                      const Icon(Icons.keyboard_return),
                      Text(
                        "Return",
                        style: TextStyle(fontSize: 6),
                      )
                    ],
                  ),
                  tooltip: 'Return',
                ),
              ),
              if (!isGuest)
                Transform.scale(
                  scale: iconSize,
                  child: IconButton(
                    onPressed: () {
                      onSaved();
                    },
                    icon: Column(
                      children: [
                        const ImageIcon(AssetImage("icons/save.png")),
                        Text(
                          "Save",
                          style: TextStyle(fontSize: 6),
                        )
                      ],
                    ),
                    tooltip: "Save",
                  ),
                ),
              if (!isGuest)

                //MARK: - EXPORT BUTTON
                Transform.scale(
                  scale: iconSize,
                  child: IconButton(
                    icon: Column(
                      children: [
                        const ImageIcon(AssetImage("icons/export2.png")),
                        Text(
                          "Export",
                          style: TextStyle(fontSize: 6),
                        )
                      ],
                    ),
                    tooltip: 'Export',
                    onPressed: () {
                      drawingCanvasKey.currentState?.export(name);
                    },
                  ),
                ),

              //MARK: - UNDO BUTTON
              Transform.scale(
                scale: iconSize,
                child: IconButton(
                  onPressed: () {
                    drawingCanvasKey.currentState?.undo();
                    refreshUI();
                  },
                  icon: Column(
                    children: [
                      const ImageIcon(AssetImage("icons/undo.png")),
                      Text(
                        "Undo",
                        style: TextStyle(fontSize: 6),
                      )
                    ],
                  ),
                  tooltip: "Undo",
                ),
              ),

              //MARK: - REDO BUTTON
              Transform.scale(
                scale: iconSize,
                child: IconButton(
                  onPressed: () {
                    drawingCanvasKey.currentState?.redo();
                    refreshUI();
                  },
                  icon: Column(
                    children: [
                      const ImageIcon(AssetImage("icons/redo.png")),
                      Text(
                        "Redo",
                        style: TextStyle(fontSize: 6),
                      )
                    ],
                  ),
                  tooltip: "Redo",
                ),
              ),
            ],
          ),
          Row(
            children: [
              //TODO: Redesign to match desired style
              Transform.scale(
                scale: iconSize,
                child: IconButton(
                  icon: Column(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.square_rounded,
                            color: fillColor == Colors.transparent
                                ? Colors.grey
                                : fillColor,
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
                      Text(
                        "Fill Color",
                        style: TextStyle(fontSize: 6),
                      )
                    ],
                  ),
                  tooltip: 'Set Fill Color',
                  onPressed: () {
                    _pickColor(context, true);
                  },
                ),
              ),

              //TODO: Redesign to match desired style
              Transform.scale(
                scale: iconSize,
                child: IconButton(
                  icon: Column(
                    children: [
                      Stack(
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
                      Text(
                        "Stroke Color",
                        style: TextStyle(fontSize: 6),
                      )
                    ],
                  ),
                  tooltip: 'Set Stroke Color',
                  onPressed: () {
                    _pickColor(context, false);
                  },
                ),
              ),

              Transform.scale(
                scale: iconSize,
                child: IconButton(
                  icon: Column(
                    children: [
                      Icon(Icons.line_weight), // Icon indicating thickness
                      Text(
                        "Thickness",
                        style: TextStyle(fontSize: 6),
                      ),
                    ],
                  ),
                  tooltip: 'Adjust Stroke Width',
                  onPressed: () {
                    _showStrokeWidthDialog(context);
                  },
                ),
              ),

              //MARK: - TOGGLE GRID VISIBILITY
              Transform.scale(
                scale: iconSize,
                child: IconButton(
                  icon: const Column(
                    children: [
                      ImageIcon(AssetImage("icons/grid.png")),
                      Text(
                        "Grid Toggle",
                        style: TextStyle(fontSize: 6),
                      )
                    ],
                  ),
                  tooltip: 'Toggle Grid',
                  onPressed: () {
                    drawingCanvasKey.currentState?.toggleGrid();
                  },
                ),
              ),
              //MARK: - TOGGLE SNAP TO GRID
              Transform.scale(
                scale: iconSize,
                child: IconButton(
                  icon: const Column(
                    children: [
                      Icon(Icons.square_foot),
                      Text(
                        "Snap to Grid",
                        style: TextStyle(fontSize: 6),
                      ),
                    ],
                  ),
                  tooltip: 'Snap to Grid',
                  onPressed: () {
                    drawingCanvasKey.currentState?.toggleSnapToGrid();
                  },
                ),
              ),


            ],
          ),
          Row(
            children: [
              // Freeform Tool
              buildToolButton(
                tool: FreeformTool(),
                tooltip: 'Freeform',
                icon: Column(
                  children: [
                    const ImageIcon(AssetImage("icons/draw.png")),
                    Text("Draw", style: TextStyle(fontSize: 6)),
                  ],
                ),
                onPressed: () {
                  drawingCanvasKey.currentState?.switchTool(FreeformTool());
                },
              ),

              // Eraser Tool
              buildToolButton(
                tool: DeleteTool(activeLayerShapes, refreshUI),
                tooltip: 'Eraser',
                icon: Column(
                  children: [
                    const ImageIcon(AssetImage("icons/eraser.png")),
                    Text("Erase", style: TextStyle(fontSize: 6)),
                  ],
                ),
                onPressed: () {
                  drawingCanvasKey.currentState?.switchTool(
                    DeleteTool(activeLayerShapes, refreshUI),
                  );
                },
              ),

              // Line Tool
              buildToolButton(
                tool: LineTool(),
                tooltip: 'Line',
                icon: Column(
                  children: [
                    const ImageIcon(AssetImage("icons/line.png")),
                    Text("Line", style: TextStyle(fontSize: 6)),
                  ],
                ),
                onPressed: () {
                  drawingCanvasKey.currentState?.switchTool(LineTool());
                },
              ),

              // Triangle Tool
              buildToolButton(
                tool: TriangleTool(),
                tooltip: 'Triangle',
                icon: Column(
                  children: [
                    const ImageIcon(AssetImage("icons/triangle.png")),
                    Text("Triangle", style: TextStyle(fontSize: 6)),
                  ],
                ),
                onPressed: () {
                  drawingCanvasKey.currentState?.switchTool(TriangleTool());
                },
              ),

              // Rectangle Tool
              buildToolButton(
                tool: RectangleTool(),
                tooltip: 'Rectangle',
                icon: Column(
                  children: [
                    const ImageIcon(AssetImage("icons/square.png")),
                    Text("Rectangle", style: TextStyle(fontSize: 6)),
                  ],
                ),
                onPressed: () {
                  drawingCanvasKey.currentState?.switchTool(RectangleTool());
                },
              ),

              // Circle Tool
              buildToolButton(
                tool: CircleTool(),
                tooltip: 'Circle',
                icon: Column(
                  children: [
                    const ImageIcon(AssetImage("icons/circle.png")),
                    Text("Circle", style: TextStyle(fontSize: 6)),
                  ],
                ),
                onPressed: () {
                  drawingCanvasKey.currentState?.switchTool(CircleTool());
                },
              ),

              // Annotation Tool
              buildToolButton(
                tool: AnnotationTool(),
                tooltip: 'Annotation',
                icon: Column(
                  children: [
                    const Icon(Icons.text_fields),
                    Text("Text Box", style: TextStyle(fontSize: 6)),
                  ],
                ),
                onPressed: () {
                  drawingCanvasKey.currentState?.switchTool(AnnotationTool());
                },
              ),
              Transform.scale(
                scale: iconSize,
                child: IconButton(
                  icon: Column(
                    children: [
                      const Icon(Icons.delete),
                      Text(
                        "Delete",
                        style: TextStyle(fontSize: 6),
                      )
                    ],
                  ),
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
              ),
            ],
          ),

          //TODO: CREATE POLYGON TOOL
          // Transform.scale(
          //                 scale: 2,
          //                 child:  IconButton(onPressed: (){
          //                    drawingCanvasKey.currentState?.switchTool(PolygonTool());
          //                 },
          //                     icon:  const ImageIcon(AssetImage("icons/freeformshapes.png"))
          //                 ),
          //               ),
          //               const SizedBox(width: 15,),

          //TODO: CONFORM THIS TO TOOL STYLING
          // You may want to add this styling to other buttons as well. Via a bool the button
          // changes looks to indicate that it is selected.

          //Removed for Video

          //MARK: - ZOOM IN/OUT TOGGLE
          // ValueListenableBuilder<bool>(
          //   valueListenable: drawingCanvasKey.currentState?.isZoomEnabledNotifier ?? ValueNotifier(false),
          //   builder: (context, isZoomEnabled, child) {
          //     return Container(
          //       decoration: isZoomEnabled
          //           ? BoxDecoration(
          //         color: Colors.grey[50], // Background color when zoom is enabled
          //         borderRadius: BorderRadius.circular(8),
          //       )
          //           : null,
          //       child: Row(
          //         children: [
          //           Transform.scale(
          //           scale: iconSize,
          //           child: IconButton(
          //             icon: ImageIcon(isZoomEnabled ? AssetImage("icons/zoomout.png") : AssetImage("icons/zoomin.png")),
          //             tooltip: 'Toggle Zoom',
          //             onPressed: () {
          //               drawingCanvasKey.currentState?.toggleZoom();
          //             },
          //           ),
          //           ),
          //           SizedBox(width: spacerSize),
          //         ],
          //       ),
          //
          //     );
          //   },
          // ),

          //TODO: DEVELOP A TOOL FOR PANNING THAT IS SEPARATE FROM ZOOM
          // currently zoom also handles pan, but we may change that
          //MARK: - PAN TOOL SELECTOR
          // Transform.scale(
          //   scale: iconSize,
          //   child: IconButton(onPressed: (){},
          //       icon:  const ImageIcon(AssetImage("icons/pan.png"))
          //   ),
          // ),
          // SizedBox(width: iconSize,),

          //MARK: - CURSOR TOOL SELECTOR
          //This may be unnecessary, currently we don't have a tool that would use this.
          //Keeping just in case.
          // Transform.scale(
          //   scale: iconSize,
          //   child: IconButton(onPressed: (){},
          //       icon:  const ImageIcon(AssetImage("icons/cursor.png"))
          //   ),
          // ),
          // SizedBox(width: iconSize,),

          //MARK: - STROKE WIDTH SLIDER
          //StrokeWidth(),
          // Slider(
          //   value: strokeWidth,
          //   min: 1.0,
          //   max: 10.0,
          //   divisions: 9,
          //   label: '${strokeWidth.toStringAsFixed(1)} px',
          //   onChanged: onUpdateStrokeWidth,
          // ),
        ],
      ))
    ]);
  }
}

class StrokeWidth extends StatefulWidget {
  final double strokeWidth;
  final Function(double) onUpdateStrokeWidth;

  const StrokeWidth({
    Key? key,
    required this.strokeWidth,
    required this.onUpdateStrokeWidth,
  }) : super(key: key);

  @override
  State<StrokeWidth> createState() => _StrokeWidthState();
}

class _StrokeWidthState extends State<StrokeWidth> {
  late double _sliderValue;

  @override
  void initState() {
    super.initState();
    _sliderValue = widget.strokeWidth;
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderThemeData(
        inactiveTrackColor: Colors.grey[300],
        activeTrackColor: lgreencolor,
        thumbColor: blackcolor,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 2.0),
        activeTickMarkColor: lgreencolor,
        inactiveTickMarkColor: Colors.grey[500],
        trackHeight: 5,
        valueIndicatorColor: lgreencolor,
        valueIndicatorStrokeColor: lgreencolor,
        valueIndicatorTextStyle: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.bold,
          color: biegecolor,
        ),
      ),
      child: Slider.adaptive(
        value: _sliderValue,
        min: 1,
        max: 16,
        divisions: 15,
        label: _sliderValue.toString(),
        onChanged: (double value) {
          setState(() {
            _sliderValue = value;
          });
          // Update DrawingCanvasState stroke width
          widget.onUpdateStrokeWidth(value);
        },
      ),
    );
  }
}

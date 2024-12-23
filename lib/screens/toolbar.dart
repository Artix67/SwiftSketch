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
  final VoidCallback onSaved;
  final List<DrawingShape> activeLayerShapes;
  final VoidCallback refreshUI;
  final double spacerSize;
  final double iconSize;
  final String name;


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

        //MARK: - SAVE BUTTON
        Transform.scale(
          scale: iconSize,
          child: IconButton(
            onPressed: () {
              onSaved();
            },
            icon: const ImageIcon(AssetImage("icons/save.png")),
            tooltip: "Save",
          ),
        ),
        SizedBox(width: spacerSize,),

        //MARK: - EXPORT BUTTON
        Transform.scale(
          scale: iconSize,
          child: IconButton(
            icon: const ImageIcon(AssetImage("icons/export2.png")),
            tooltip: 'Export',
            onPressed: () {
              drawingCanvasKey.currentState?.export(name);
            },
          ),
        ),
        SizedBox(width: spacerSize,),

        //MARK: - UNDO BUTTON
        Transform.scale(
          scale: iconSize,
          child: IconButton(
            onPressed: () {
              drawingCanvasKey.currentState?.undo();
              refreshUI();
            },
            icon: const ImageIcon(AssetImage("icons/undo.png")),
            tooltip: "Undo",
          ),
        ),
        SizedBox(width: spacerSize,),

        //MARK: - REDO BUTTON
        Transform.scale(
          scale: iconSize,
          child: IconButton(
            onPressed: () {
              drawingCanvasKey.currentState?.redo();
              refreshUI();
            },
            icon: const ImageIcon(AssetImage("icons/redo.png")),
            tooltip: "Redo",
          ),
        ),
        SizedBox(width: spacerSize,),

        //TODO: Move to Settings
        // Slider(
        //   value: snapSensitivity,
        //   min: 1.0,
        //   max: 5.0,
        //   divisions: 4,
        //   label: '${snapSensitivity.toStringAsFixed(1)}x',
        //   onChanged: (value) {
        //     onUpdateSnapSensitivity(value);
        //   },
        // ),

        //TODO: Move to Settings
        // Slider(
        //   value: gridSize,
        //   min: 5.0,
        //   max: 50.0,
        //   divisions: 9,
        //   label: '${gridSize.toInt()} px',
        //   onChanged: onUpdateGridSize,
        // ),

        //MARK: - STROKE WIDTH SLIDER
        Slider(
          value: strokeWidth,
          min: 1.0,
          max: 10.0,
          divisions: 9,
          label: '${strokeWidth.toStringAsFixed(1)} px',
          onChanged: onUpdateStrokeWidth,
        ),

        //TODO: Redesign to match desired style
        Transform.scale(
        scale: iconSize,
          child: IconButton(
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
        ),
        SizedBox(width: spacerSize,),

        //TODO: Redesign to match desired style
    Transform.scale(
    scale: iconSize,
    child: IconButton(
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
    ),
        SizedBox(width: spacerSize,),

        // MARK: - FREEFORM TOOL SELECTOR
        Transform.scale(
          scale: iconSize,
          child:  IconButton(
            icon: const ImageIcon(AssetImage("icons/draw.png")),
            tooltip: 'Freeform',
            onPressed: () {
              drawingCanvasKey.currentState?.switchTool(FreeformTool());
            },
          ),
        ),
        SizedBox(width: spacerSize,),

        //MARK: - LINE TOOL SELECTOR
        Transform.scale(
          scale: iconSize,
          child: IconButton(
            icon:  const ImageIcon(AssetImage("icons/line.png")),
            tooltip: 'Line',
            onPressed: () {
              drawingCanvasKey.currentState?.switchTool(LineTool());
            },
          ),
        ),
        SizedBox(width: spacerSize,),

        //MARK: - TRIANGLE TOOL SELECTOR
        Transform.scale(
          scale: iconSize,
          child:  IconButton(
            icon: const ImageIcon(AssetImage("icons/triangle.png")),
            tooltip: 'Triangle',
            onPressed: () {
              drawingCanvasKey.currentState?.switchTool(TriangleTool());
            },
          ),
        ),
        SizedBox(width: spacerSize,),

        //MARK: - SQUARE TOOL SELECTOR
        Transform.scale(
          scale: iconSize,
          child: IconButton(
            icon: const ImageIcon(AssetImage("icons/square.png")),
            tooltip: 'Rectangle',
            onPressed: () {
              drawingCanvasKey.currentState?.switchTool(RectangleTool());
            },
          ),
        ),

        //MARK: - CIRCLE TOOL SELECTOR
        Transform.scale(
          scale: iconSize,
          child: IconButton(
            icon: const ImageIcon(AssetImage("icons/circle.png")),
            tooltip: 'Circle',
            onPressed: () {
              drawingCanvasKey.currentState?.switchTool(CircleTool());
            },
          ),
        ),
        SizedBox(width: spacerSize,),

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

        //MARK: - ANNOTATION TOOL
        Transform.scale(
          scale: iconSize,
          child:  IconButton(onPressed: (){
            drawingCanvasKey.currentState?.switchTool(AnnotationTool());
          },
              icon:  const ImageIcon(AssetImage("icons/label.png")),
              tooltip: 'Annotation Tool',
          ),
        ),
        SizedBox(width: spacerSize,),

        //MARK: - ERASER TOOL SELECTOR
        Transform.scale(
          scale: iconSize,
          child: IconButton(
            icon: const ImageIcon(AssetImage("icons/eraser.png")),
            tooltip: 'Eraser',
            onPressed: () {
              drawingCanvasKey.currentState?.switchTool(DeleteTool(
                activeLayerShapes,
                    () {
                  refreshUI();
                },
              ));
            },
          ),
        ),

        //MARK: - TOGGLE GRID VISIBILITY
        Transform.scale(
          scale: iconSize,
          child: IconButton(
            icon: const ImageIcon(AssetImage("icons/grid.png")),
            tooltip: 'Toggle Grid',
            onPressed: () {
              drawingCanvasKey.currentState?.toggleGrid();
            },
          ),
        ),
        SizedBox(width: spacerSize,),

        //MARK: - TOGGLE SNAP TO GRID
        Transform.scale(
          scale: iconSize,
          child:  IconButton(
            icon: const Icon(Icons.square_foot),
            tooltip: 'Snap to Grid',
            onPressed: () {
              drawingCanvasKey.currentState?.toggleSnapToGrid();
            },
          ),
        ),
        SizedBox(width: spacerSize,),

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


        Transform.scale(
          scale: iconSize,
          child: IconButton (
            icon: const Icon(Icons.delete),
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
        SizedBox(width: spacerSize,),

        //TODO: Resdeign to match desired style
        //MARK: - RETURN TO HOME SCREEN
        IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const HomeScreen();
            }));
          },
          icon: const Icon(Icons.keyboard_return),
          tooltip: 'Home',
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import '../app_colors.dart';
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

const double iconBoxSize = 24;
const double textBoxSizeWidth = 45;
const double textBoxSizeHeight = 12;

class Toolbar extends StatelessWidget {
  final Color fillColor;
  final Color strokeColor;
  final double strokeWidth;
  final double gridSize;
  final double snapSensitivity;
  final Function(double) onUpdateStrokeWidth;
  final Function(Color, Color) onUpdateColors;
  final Function(double) onUpdateSnapSensitivity;
  final GlobalKey<DrawingCanvasState> drawingCanvasKey;
  final VoidCallback onDeleteToolUpdate;
  final VoidCallback onSaved;
  final List<DrawingShape> activeLayerShapes;
  final VoidCallback refreshUI;
  final double spacerSize;
  final double iconSize;
  final double iconLabelSize;
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
    required this.onUpdateColors,
    required this.onUpdateSnapSensitivity,
    required this.drawingCanvasKey,
    required this.onDeleteToolUpdate,
    required this.onSaved,
    required this.activeLayerShapes,
    required this.refreshUI,
    required this.spacerSize,
    required this.iconSize,
    required this.iconLabelSize,
    required this.name,
    required this.isGuest,
  });

  void _pickColor(BuildContext context, bool isFill) {
    Color localTempColor = isFill ? fillColor : strokeColor;
    showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context,
              void Function(void Function()) setStateDialog) {
            return AlertDialog(
              title: Text(isFill ? 'Pick Fill Color' : 'Pick Stroke Color'),
              content: SingleChildScrollView(
                child: ColorPicker(
                  color: localTempColor,
                  onColorChanged: (Color newColor) {
                    setStateDialog(() => localTempColor = newColor);
                  },
                  showColorName: true,
                  enableShadesSelection: true,
                ),
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(dialogContext).pop(false),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: lgreycolor,
                        foregroundColor: blackcolor,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      child: const Text("Cancel"),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () => Navigator.of(dialogContext).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: lgreencolor,
                        foregroundColor: whitecolor,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      child: const Text("OK"),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    ).then((didConfirm) {
      if (didConfirm == true) {
        if (isFill) {
          onUpdateColors(localTempColor, strokeColor);
        } else {
          onUpdateColors(fillColor, localTempColor);
        }
      }
    });
  }

  // TODO: Show Stroke Thickness Dialog
  void _showStrokeWidthDialog(BuildContext context) {
    double tempStrokeWidth = drawingCanvasKey.currentState!.strokeWidth;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Adjust Stroke Thickness"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: lgreycolor,
                        foregroundColor: blackcolor,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                      onPressed: () => Navigator.of(context).pop(), // Cancel
                      child: const Text("Cancel"),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: lgreencolor,
                        foregroundColor: whitecolor,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                      onPressed: () {
                        drawingCanvasKey.currentState!
                            .updateStrokeWidth(tempStrokeWidth);
                        Navigator.of(context).pop();
                      },
                      child: const Text("OK"),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  //TODO: Show Snap Range Dialog
  void _showSnapRangeDialog(BuildContext context) {
    double tempSnapSensitivity = drawingCanvasKey.currentState!.snapSensitivity;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Adjust Snap Range"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  StrokeWidth(
                    strokeWidth: tempSnapSensitivity,
                    onUpdateStrokeWidth: (value) {
                      setStateDialog(() {
                        tempSnapSensitivity = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: lgreycolor,
                        foregroundColor: blackcolor,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                      onPressed: () => Navigator.of(context).pop(), // Cancel
                      child: const Text("Cancel"),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: lgreencolor,
                        foregroundColor: whitecolor,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                      ),
                      onPressed: () {
                        drawingCanvasKey.currentState!
                            .updateSnapSensitivity(tempSnapSensitivity);
                        Navigator.of(context).pop();
                      },
                      child: const Text("OK"),
                    ),
                  ],
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
                  height: 40,
                  decoration: BoxDecoration(
                    color: whitecolor,
                    borderRadius: BorderRadius.circular(6),
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
    return AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: beigecolor,
        actions: <Widget>[
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //TODO: UTILITY ROW
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(width: spacerSize),

                  //TODO: RETURN BUTTON
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: redcolor,
                                          // Red background
                                          foregroundColor: whitecolor,
                                          // White text
                                          shape: const StadiumBorder(),
                                          // Pill shape
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 12,
                                          ),
                                        ),
                                        child: const Text("Don't Save"),
                                      ),
                                      const Spacer(),
                                      ElevatedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(null),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: lgreycolor,
                                          foregroundColor: blackcolor,
                                          shape: const StadiumBorder(),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 12,
                                          ),
                                        ),
                                        child: const Text("Cancel"),
                                      ),
                                      const SizedBox(width: 8),
                                      const Spacer(),
                                      ElevatedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(true),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: lgreencolor,
                                          foregroundColor: whitecolor,
                                          shape: const StadiumBorder(),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                            vertical: 12,
                                          ),
                                        ),
                                        child: const Text("Save"),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          );

                          // Handle user's choice
                          if (shouldSave == true) {
                            onSaved(); // Call the save function
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const HomeScreen();
                            }));
                          } else if (shouldSave == false) {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const HomeScreen();
                            }));
                          }
                          // If shouldSave is null (Cancel), do nothing
                        } else {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const LoginScreen();
                          }));
                        }
                      },
                      icon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: iconBoxSize,
                            height: iconBoxSize,
                            child: Icon(Icons.keyboard_return),
                          ),
                          SizedBox(
                            width: textBoxSizeWidth,
                            height: textBoxSizeHeight,
                            child: Center(
                              child: Text(
                                "Return",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: iconLabelSize),
                              ),
                            ),
                          ),
                        ],
                      ),
                      tooltip: 'Return',
                    ),
                  ),

                  //TODO: SAVE BUTTON
                  if (!isGuest)
                    Transform.scale(
                      scale: iconSize,
                      child: IconButton(
                        onPressed: () {
                          onSaved();
                        },
                        icon: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: iconBoxSize,
                              height: iconBoxSize,
                              child: ImageIcon(AssetImage("icons/save.png")),
                            ),
                            SizedBox(
                              width: textBoxSizeWidth,
                              height: textBoxSizeHeight,
                              child: Center(
                                child: Text(
                                  "Save",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: iconLabelSize),
                                ),
                              ),
                            ),
                          ],
                        ),
                        tooltip: "Save",
                      ),
                    ),

                  //TODO: - EXPORT BUTTON
                  if (!isGuest)
                    Transform.scale(
                      scale: iconSize,
                      child: IconButton(
                        icon: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: iconBoxSize,
                              height: iconBoxSize,
                              child: ImageIcon(AssetImage("icons/export2.png")),
                            ),
                            SizedBox(
                              width: textBoxSizeWidth,
                              height: textBoxSizeHeight,
                              child: Center(
                                child: Text(
                                  "Export",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: iconLabelSize),
                                ),
                              ),
                            ),
                          ],
                        ),
                        tooltip: 'Export',
                        onPressed: () {
                          drawingCanvasKey.currentState?.export(name);
                        },
                      ),
                    ),

                  //TODO: - UNDO BUTTON
                  Transform.scale(
                    scale: iconSize,
                    child: IconButton(
                      onPressed: () {
                        drawingCanvasKey.currentState?.undo();
                        refreshUI();
                      },
                      icon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: iconBoxSize,
                            height: iconBoxSize,
                            child: ImageIcon(AssetImage("icons/undo.png")),
                          ),
                          SizedBox(
                            width: textBoxSizeWidth,
                            height: textBoxSizeHeight,
                            child: Center(
                              child: Text(
                                "Undo",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: iconLabelSize),
                              ),
                            ),
                          ),
                        ],
                      ),
                      tooltip: "Undo",
                    ),
                  ),

                  //TODO: - REDO BUTTON
                  Transform.scale(
                    scale: iconSize,
                    child: IconButton(
                      onPressed: () {
                        drawingCanvasKey.currentState?.redo();
                        refreshUI();
                      },
                      icon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: iconBoxSize,
                            height: iconBoxSize,
                            child: ImageIcon(AssetImage("icons/redo.png")),
                          ),
                          SizedBox(
                            width: textBoxSizeWidth,
                            height: textBoxSizeHeight,
                            child: Center(
                              child: Text(
                                "Redo",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: iconLabelSize),
                              ),
                            ),
                          ),
                        ],
                      ),
                      tooltip: "Redo",
                    ),
                  ),
                ],
              ),

              // TODO: SETTINGS ROW
              Row(
                children: [
                  //TODO: Fill Color
                  Transform.scale(
                    scale: iconSize,
                    child: IconButton(
                      icon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: iconBoxSize,
                                height: iconBoxSize,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Icon(
                                      Icons.square_rounded,
                                      color: fillColor,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: textBoxSizeWidth,
                            height: textBoxSizeHeight,
                            child: Center(
                              child: Text(
                                "Fill Color",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: iconLabelSize),
                              ),
                            ),
                          ),
                        ],
                      ),
                      tooltip: 'Set Fill Color',
                      onPressed: () {
                        _pickColor(context, true);
                      },
                    ),
                  ),

                  //TODO: STROKE BUTTON
                  Transform.scale(
                    scale: iconSize,
                    child: IconButton(
                      icon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: iconBoxSize,
                            height: iconBoxSize,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Icon(
                                  Icons.crop_square_rounded,
                                  color: strokeColor,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: textBoxSizeWidth,
                            height: textBoxSizeHeight,
                            child: Center(
                              child: Text(
                                "Stroke Color",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: iconLabelSize),
                              ),
                            ),
                          ),
                        ],
                      ),
                      tooltip: 'Set Stroke Color',
                      onPressed: () {
                        _pickColor(context, false);
                      },
                    ),
                  ),

                  //TODO: STROKE THICKNESS BUTTON
                  Transform.scale(
                    scale: iconSize,
                    child: IconButton(
                      icon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: iconBoxSize,
                            height: iconBoxSize,
                            child: Icon(Icons.line_weight),
                          ),
                          SizedBox(
                            width: textBoxSizeWidth,
                            height: textBoxSizeHeight,
                            child: Center(
                              child: Text(
                                "Thickness",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: iconLabelSize),
                              ),
                            ),
                          ),
                        ],
                      ),
                      tooltip: 'Adjust Stroke Width',
                      onPressed: () {
                        _showStrokeWidthDialog(context);
                      },
                    ),
                  ),

                  //TODO: - TOGGLE GRID VISIBILITY
                  ValueListenableBuilder<bool>(
                    valueListenable:
                        drawingCanvasKey.currentState!.showGridNotifier,
                    builder: (context, isGridOn, _) {
                      return Transform.scale(
                        scale: iconSize,
                        child: IconButton(
                          tooltip: 'Toggle Grid',
                          onPressed: () {
                            drawingCanvasKey.currentState?.toggleGrid();
                          },
                          icon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: iconBoxSize,
                                height: iconBoxSize,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    const ImageIcon(
                                        AssetImage("icons/grid.png")),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        width: 12,
                                        height: 12,
                                        decoration: const BoxDecoration(
                                          color: beigecolor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          isGridOn
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          size: 11,
                                          color: isGridOn ? blackcolor : disablecolor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: textBoxSizeWidth,
                                height: textBoxSizeHeight,
                                child: Center(
                                  child: Text(
                                    isGridOn ? "Hide Grid" : "Show Grid",
                                    style: TextStyle(fontSize: iconLabelSize),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  //TODO: - TOGGLE GRID SIZE
                  ValueListenableBuilder<bool>(
                    valueListenable:
                        drawingCanvasKey.currentState!.gridSizeNotifier,
                    builder: (context, isGridSmall, _) {
                      return Transform.scale(
                        scale: iconSize,
                        child: IconButton(
                          tooltip: 'Grid Size',
                          onPressed: () {
                            drawingCanvasKey.currentState?.toggleGridSize();
                          },
                          icon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: iconBoxSize,
                                height: iconBoxSize,
                                child: isGridSmall
                                    ? const ImageIcon(
                                        AssetImage("icons/grid.png"))
                                    : const ImageIcon(
                                        AssetImage("icons/grid2.png")),
                              ),
                              SizedBox(
                                width: textBoxSizeWidth,
                                height: textBoxSizeHeight,
                                child: Center(
                                  child: Text(
                                    "Grid Size",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: iconLabelSize),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  //TODO: - TOGGLE SNAP TO GRID
                  ValueListenableBuilder<bool>(
                    valueListenable:
                        drawingCanvasKey.currentState!.snapToGridNotifier,
                    builder: (context, isSnapEnabled, _) {
                      return Transform.scale(
                        scale: iconSize,
                        child: IconButton(
                          tooltip: 'Snap to Grid',
                          onPressed: () {
                            drawingCanvasKey.currentState?.toggleSnapToGrid();
                          },
                          icon: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: iconBoxSize,
                                height: iconBoxSize,
                                child: ImageIcon(
                                  const AssetImage("icons/magnet.png"),
                                  color: isSnapEnabled ? blackcolor : disablecolor,
                                ),
                              ),
                              SizedBox(
                                width: textBoxSizeWidth,
                                height: textBoxSizeHeight,
                                child: Center(
                                  child: Text(
                                    "Snap",
                                    style: TextStyle(fontSize: iconLabelSize),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  //TODO: Snap Range
//TODO: STROKE THICKNESS BUTTON
                  Transform.scale(
                    scale: iconSize,
                    child: IconButton(
                      icon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: iconBoxSize,
                            height: iconBoxSize,
                            child: ImageIcon(
                              AssetImage("icons/signal.png"),
                            ),
                          ),
                          SizedBox(
                            width: textBoxSizeWidth,
                            height: textBoxSizeHeight,
                            child: Center(
                              child: Text(
                                "Snap Range",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: iconLabelSize),
                              ),
                            ),
                          ),
                        ],
                      ),
                      tooltip: 'Adjust Snap Sensitivity',
                      onPressed: () {
                        _showSnapRangeDialog(context);
                      },
                    ),
                  ),
                ],
              ),

              //TODO: TOOL ROW
              Row(
                children: [
                  // TODO: Freeform Tool
                  buildToolButton(
                    tool: FreeformTool(),
                    tooltip: 'Freeform',
                    icon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: iconBoxSize,
                          height: iconBoxSize,
                          child: ImageIcon(AssetImage("icons/draw.png")),
                        ),
                        SizedBox(
                          width: textBoxSizeWidth,
                          height: textBoxSizeHeight,
                          child: Center(
                            child: Text(
                              "Draw",
                              style: TextStyle(fontSize: iconLabelSize),
                            ),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      drawingCanvasKey.currentState?.switchTool(FreeformTool());
                    },
                  ),

                  //TODO:  Eraser Tool
                  buildToolButton(
                    tool: DeleteTool(activeLayerShapes, refreshUI),
                    tooltip: 'Eraser',
                    icon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: iconBoxSize,
                          height: iconBoxSize,
                          child: ImageIcon(AssetImage("icons/eraser.png")),
                        ),
                        SizedBox(
                          width: textBoxSizeWidth,
                          height: textBoxSizeHeight,
                          child: Center(
                            child: Text(
                              "Eraser",
                              style: TextStyle(fontSize: iconLabelSize),
                            ),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      drawingCanvasKey.currentState?.switchTool(
                        DeleteTool(activeLayerShapes, refreshUI),
                      );
                    },
                  ),

                  //TODO:  Line Tool
                  buildToolButton(
                    tool: LineTool(),
                    tooltip: 'Line',
                    icon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: iconBoxSize,
                          height: iconBoxSize,
                          child: ImageIcon(AssetImage("icons/line.png")),
                        ),
                        SizedBox(
                          width: textBoxSizeWidth,
                          height: textBoxSizeHeight,
                          child: Center(
                            child: Text(
                              "Line",
                              style: TextStyle(fontSize: iconLabelSize),
                            ),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      drawingCanvasKey.currentState?.switchTool(LineTool());
                    },
                  ),

                  //TODO:  Triangle Tool
                  buildToolButton(
                    tool: TriangleTool(),
                    tooltip: 'Triangle',
                    icon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: iconBoxSize,
                          height: iconBoxSize,
                          child: ImageIcon(AssetImage("icons/triangle.png")),
                        ),
                        SizedBox(
                          width: textBoxSizeWidth,
                          height: textBoxSizeHeight,
                          child: Center(
                            child: Text(
                              "Triangle",
                              style: TextStyle(fontSize: iconLabelSize),
                            ),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      drawingCanvasKey.currentState?.switchTool(TriangleTool());
                    },
                  ),

                  //TODO:  Rectangle Tool
                  buildToolButton(
                    tool: RectangleTool(),
                    tooltip: 'Rectangle',
                    icon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: iconBoxSize,
                          height: iconBoxSize,
                          child: ImageIcon(AssetImage("icons/square.png")),
                        ),
                        SizedBox(
                          width: textBoxSizeWidth,
                          height: textBoxSizeHeight,
                          child: Center(
                            child: Text(
                              "Rectangle",
                              style: TextStyle(fontSize: iconLabelSize),
                            ),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      drawingCanvasKey.currentState
                          ?.switchTool(RectangleTool());
                    },
                  ),

                  //TODO:  Circle Tool
                  buildToolButton(
                    tool: CircleTool(),
                    tooltip: 'Circle',
                    icon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: iconBoxSize,
                          height: iconBoxSize,
                          child: ImageIcon(AssetImage("icons/circle.png")),
                        ),
                        SizedBox(
                          width: textBoxSizeWidth,
                          height: textBoxSizeHeight,
                          child: Center(
                            child: Text(
                              "Circle",
                              style: TextStyle(fontSize: iconLabelSize),
                            ),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      drawingCanvasKey.currentState?.switchTool(CircleTool());
                    },
                  ),

                  //TODO:  Annotation Tool
                  buildToolButton(
                    tool: AnnotationTool(),
                    tooltip: 'Annotation',
                    icon: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: iconBoxSize,
                          height: iconBoxSize,
                          child: Icon(Icons.text_fields),
                        ),
                        SizedBox(
                          width: textBoxSizeWidth,
                          height: textBoxSizeHeight,
                          child: Center(
                            child: Text(
                              "Text Box",
                              style: TextStyle(fontSize: iconLabelSize),
                            ),
                          ),
                        ),
                      ],
                    ),
                    onPressed: () {
                      drawingCanvasKey.currentState
                          ?.switchTool(AnnotationTool());
                    },
                  ),

                  //TODO: RESET BUTTON
                  Transform.scale(
                    scale: iconSize,
                    child: IconButton(
                      icon: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            width: iconBoxSize,
                            height: iconBoxSize,
                            child: Icon(Icons.delete),
                          ),
                          SizedBox(
                            width: textBoxSizeWidth,
                            height: textBoxSizeHeight,
                            child: Center(
                              child: Text(
                                "Reset",
                                style: TextStyle(fontSize: iconLabelSize),
                              ),
                            ),
                          ),
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: redcolor,
                                      foregroundColor: whitecolor,
                                      shape: const StadiumBorder(),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                    ),
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text('Reset'),
                                  ),
                                  const Spacer(),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: lgreycolor,
                                      foregroundColor: blackcolor,
                                      shape: const StadiumBorder(),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                    ),
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text('Cancel'),
                                  ),
                                ],
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

                  SizedBox(width: spacerSize),
                ],
              ),

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
            ],
          ))
        ]);
  }
}

class StrokeWidth extends StatefulWidget {
  final double strokeWidth;
  final Function(double) onUpdateStrokeWidth;

  const StrokeWidth({
    super.key,
    required this.strokeWidth,
    required this.onUpdateStrokeWidth,
  });

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
      data: const SliderThemeData(
        inactiveTrackColor: lgreycolor,
        activeTrackColor: lgreycolor,
        thumbColor: placeholdercolor,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 2.0),
        activeTickMarkColor: placeholdercolor,
        inactiveTickMarkColor: placeholdercolor,
        trackHeight: 5,
        valueIndicatorColor: lgreencolor,
        valueIndicatorStrokeColor: lgreencolor,
        valueIndicatorTextStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: whitecolor,
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
          widget.onUpdateStrokeWidth(value);
        },
      ),
    );
  }
}

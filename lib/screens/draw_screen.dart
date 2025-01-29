import 'package:flutter/material.dart';
import 'package:swift_sketch/screens/toolbar.dart';
import 'package:swift_sketch/screens/layers_tab.dart';
import '../app_colors.dart';
import '../drawing_canvas.dart';
import '../models/layer.dart';
import 'package:swift_sketch/ProjectManager.dart';

class Drawscreen extends StatefulWidget {
  final String projectName;
  final bool exportImmediately;
  final bool isGuest;

  const Drawscreen(
      {super.key,
      required this.projectName,
      required this.exportImmediately,
      required this.isGuest});

  @override
  State<Drawscreen> createState() => _Drawscreen();
}

class _Drawscreen extends State<Drawscreen> {
  final GlobalKey<DrawingCanvasState> _drawingCanvasKey =
      GlobalKey<DrawingCanvasState>();
  final ProjectManager _projectManager = ProjectManager();

  Color _fillColor = Colors.white;
  Color _strokeColor = Colors.black;
  double _strokeWidth = 4.0;
  double _snapSensitivity = 1;
  final double _gridSize = 10.0;
  final double _iconSize = 1.25;
  final double _iconLabelSize = 8;
  final double _spacerSize = 1;
  late bool isGuest;

  final ValueNotifier<List<Layer>> _layersNotifier =
      ValueNotifier([Layer(id: "1", name: "Layer 1", shapes: [])]);

  final ValueNotifier<int> _selectedLayerIndex = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    isGuest = widget.isGuest;
    _loadProject();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_layersNotifier.value.isNotEmpty) {
        _drawingCanvasKey.currentState
            ?.setActiveLayer(_layersNotifier.value[_selectedLayerIndex.value]);
      }
    });
    if (widget.exportImmediately) {
      _triggerExport();
    }
  }

  void updateGuestStatus() {
    setState(() {
      isGuest = false;
    });
  }

  void _triggerExport() {
    Future.delayed(const Duration(milliseconds: 500), () {
      _drawingCanvasKey.currentState?.export(widget.projectName);
    });
  }

  Future<void> _loadProject() async {
    List<Layer> layers = await _projectManager.loadProject(widget.projectName);
    setState(() {
      if (layers.isNotEmpty) {
        _layersNotifier.value = layers;
        _drawingCanvasKey.currentState
            ?.setActiveLayer(layers[_selectedLayerIndex.value]);
      }
    });
  }

  void _saveProject() async {
    List<Layer> layers = _layersNotifier.value;
    await _projectManager.saveProject(widget.projectName, layers);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Project saved successfully')),
    );
  }

  void _updateStrokeWidth(double value) {
    setState(() {
      _strokeWidth = value;
    });
    _drawingCanvasKey.currentState?.updateStrokeWidth(value);
  }

  void _updateSnapSensitivity(double value) {
    setState(() {
      _snapSensitivity = value;
    });
    _drawingCanvasKey.currentState?.updateSnapSensitivity(value);
  }

  void _updateColors(Color fillColor, Color strokeColor) {
    setState(() {
      _fillColor = fillColor;
      _strokeColor = strokeColor;
    });
    _drawingCanvasKey.currentState?.updateColors(fillColor, strokeColor);
  }

  void _addLayer() {
    final newLayer = Layer(
      id: DateTime.now().toIso8601String(),
      name: "Layer ${_layersNotifier.value.length + 1}",
      shapes: [],
      isVisible: true,
    );
    _layersNotifier.value = List.from(_layersNotifier.value)..add(newLayer);
    _selectedLayerIndex.value = _layersNotifier.value.length - 1;
    _drawingCanvasKey.currentState?.setActiveLayer(newLayer);
  }

  void _removeLayer() {
    if (_layersNotifier.value.length > 1) {
      final List<Layer> updatedLayers = List<Layer>.from(_layersNotifier.value);
      updatedLayers.removeAt(_selectedLayerIndex.value);
      _selectedLayerIndex.value =
          (_selectedLayerIndex.value > 0) ? _selectedLayerIndex.value - 1 : 0;

      _layersNotifier.value = updatedLayers;
      _drawingCanvasKey.currentState
          ?.setActiveLayer(_layersNotifier.value[_selectedLayerIndex.value]);
    }
  }

  Future<void> _confirmRemoveLayer() async {
    if (_layersNotifier.value.length <= 1) {
      return;
    }
    final shouldRemove = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Layer'),
        content: const Text('Are you sure you want to delete this layer?'),
        backgroundColor: beigecolor,
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
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text("Delete"),
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
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text("Cancel"),
              ),
            ],
          ),
        ],
      ),
    );
    if (shouldRemove == true) {
      _removeLayer();
    }
  }

  void _selectLayer(int index) {
    setState(() {
      _selectedLayerIndex.value = index;
    });
    _drawingCanvasKey.currentState
        ?.setActiveLayer(_layersNotifier.value[_selectedLayerIndex.value]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Toolbar(
          fillColor: _fillColor,
          strokeColor: _strokeColor,
          strokeWidth: _strokeWidth,
          gridSize: _gridSize,
          snapSensitivity: _snapSensitivity,
          onUpdateStrokeWidth: _updateStrokeWidth,
          onUpdateColors: _updateColors,
          drawingCanvasKey: _drawingCanvasKey,
          onDeleteToolUpdate: () {
            setState(() {});
          },
          onSaved: _saveProject,
          activeLayerShapes:
              _layersNotifier.value[_selectedLayerIndex.value].shapes,
          refreshUI: () {
            setState(() {});
          },
          onUpdateSnapSensitivity: _updateSnapSensitivity,
          iconSize: _iconSize,
          iconLabelSize: _iconLabelSize,
          spacerSize: _spacerSize,
          name: widget.projectName,
          isGuest: isGuest,
          updateGuestStatus: updateGuestStatus,
        ),
      ),
      body: Row(
        children: [
          Expanded(
            child: DrawingCanvas(
              key: _drawingCanvasKey,
              layersNotifier: _layersNotifier,
              initialSnapSensitivity: _snapSensitivity,
            ),
          ),
          LayersTab(
            layersNotifier: _layersNotifier,
            selectedLayerIndexNotifier: _selectedLayerIndex,
            onAddLayer: _addLayer,
            onRemoveLayer: _confirmRemoveLayer,
            onSelectLayer: _selectLayer,
          ),
        ],
      ),
    );
  }
}

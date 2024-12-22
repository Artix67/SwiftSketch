import 'package:flutter/material.dart';
import 'package:swift_sketch/screens/toolbar.dart';
import 'package:swift_sketch/screens/layers_tab.dart';
import '../drawing_canvas.dart';
import '../models/layer.dart';

class Drawscreen extends StatefulWidget {

  const Drawscreen({super.key});

  @override
  State<Drawscreen> createState() => _Drawscreen();
}

class _Drawscreen extends State<Drawscreen> {
  final GlobalKey<DrawingCanvasState> _drawingCanvasKey = GlobalKey<DrawingCanvasState>();

  Color _fillColor = Colors.transparent;
  Color _strokeColor = Colors.black;
  double _strokeWidth = 4.0;
  double _gridSize = 10.0;
  double _snapSensitivity = 2.0;

  final ValueNotifier<List<Layer>> _layersNotifier = ValueNotifier([
    Layer(id: "1", name: "Layer 1", shapes: [])
  ]);

  final ValueNotifier<int> _selectedLayerIndex = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_layersNotifier.value.isNotEmpty) {
        _drawingCanvasKey.currentState?.setActiveLayer(_layersNotifier.value[_selectedLayerIndex.value]);
      }
    });
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

  void _updateGridSize(double value) {
    setState(() {
      _gridSize = value;
    });
    _drawingCanvasKey.currentState?.updateGridSize(value);
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
      _selectedLayerIndex.value = (_selectedLayerIndex.value > 0) ? _selectedLayerIndex.value - 1 : 0;

      _layersNotifier.value = updatedLayers;
      _drawingCanvasKey.currentState?.setActiveLayer(_layersNotifier.value[_selectedLayerIndex.value]);
    }
  }

  Future<void> _confirmRemoveLayer() async {
    if (_layersNotifier.value.length <= 1) return; // Prevent removing the last layer
    final shouldRemove = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Layer'),
        content: const Text('Are you sure you want to delete this layer?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: const Text('Delete'),
            onPressed: () => Navigator.of(context).pop(true),
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
    _drawingCanvasKey.currentState?.setActiveLayer(_layersNotifier.value[_selectedLayerIndex.value]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Toolbar(
            fillColor: _fillColor,
            strokeColor: _strokeColor,
            strokeWidth: _strokeWidth,
            gridSize: _gridSize,
            snapSensitivity: _snapSensitivity,
            onUpdateStrokeWidth: _updateStrokeWidth,
            onUpdateGridSize: _updateGridSize,
            onUpdateColors: _updateColors,
            drawingCanvasKey: _drawingCanvasKey,
            onDeleteToolUpdate: () {
              setState(() {});
            },
            activeLayerShapes: _layersNotifier.value[_selectedLayerIndex.value].shapes,
            refreshUI: () {
              setState(() {});
            },
            onUpdateSnapSensitivity: _updateSnapSensitivity,
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
      ),
    );
  }
}
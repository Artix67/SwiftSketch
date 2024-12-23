import 'package:flutter/material.dart' show BorderRadius, BoxDecoration, BuildContext, Color, Colors, Column, Container, EdgeInsets, Expanded, GestureDetector, Icon, IconButton, Icons, ListView, MainAxisAlignment, Row, StatelessWidget, Text, TextStyle, ValueListenableBuilder, ValueNotifier, VoidCallback, Widget;

import '../models/layer.dart';
const Color dgreencolor = Color(0xFF181C14);
const Color lgreencolor = Color(0xFF697565);
const Color biegecolor = Color(0xFFCBC2B4);
const Color redcolor = Color(0xFFAB3E2B);
const Color bluecolor = Color(0xFF11487A);
const Color blackcolor = Color(0xFF181818);
const Color midgreencolor = Color(0xFF3C3D37);

class LayersTab extends StatelessWidget {
  final ValueNotifier<List<Layer>> layersNotifier;
  final ValueNotifier<int> selectedLayerIndexNotifier;
  final VoidCallback onAddLayer;
  final VoidCallback onRemoveLayer;
  final Function(int) onSelectLayer;

  const LayersTab({
    super.key,
    required this.layersNotifier,
    required this.selectedLayerIndexNotifier,
    required this.onAddLayer,
    required this.onRemoveLayer,
    required this.onSelectLayer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(4.0),
      color: Colors.grey[200],
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'Add Layer',
                onPressed: onAddLayer,
              ),
              IconButton(
                icon: const Icon(Icons.remove),
                tooltip: 'Remove Layer',
                onPressed: onRemoveLayer,
              ),
            ],
          ),
          Expanded(
            child: ValueListenableBuilder<List<Layer>>(
              valueListenable: layersNotifier,
              builder: (context, layers, _) {
                return ValueListenableBuilder<int>(
                  valueListenable: selectedLayerIndexNotifier,
                  builder: (context, selectedLayerIndex, _) {
                    return ListView.builder(
                      itemCount: layers.length,
                      itemBuilder: (context, index) {
                        final layer = layers[index];
                        return GestureDetector(
                          onTap: () => onSelectLayer(index),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6.0, vertical: 0.0),
                            margin: const EdgeInsets.symmetric(vertical: 2.0),
                            decoration: BoxDecoration(
                              color: selectedLayerIndex == index
                                  ? lgreencolor
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    layer.name,
                                    style: const TextStyle(fontSize: 14.0),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    layer.isVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    size: 18.0,
                                    color: layer.isVisible
                                        ? Colors.black
                                        : Colors.black38,
                                  ),
                                  onPressed: () {
                                    layersNotifier.value = List.from(layers)
                                      ..[index] = Layer(
                                        id: layer.id,
                                        name: layer.name,
                                        shapes: layer.shapes,
                                        isVisible: !layer.isVisible,
                                      );
                                  },
                                  tooltip: layer.isVisible
                                      ? 'Hide Layer'
                                      : 'Show Layer',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
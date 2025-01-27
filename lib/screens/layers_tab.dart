import 'package:flutter/material.dart' show BorderRadius, BoxDecoration, BuildContext, Color, Colors, Column, Container, EdgeInsets, Expanded, GestureDetector, Icon, IconButton, Icons, ListView, MainAxisAlignment, Row, StatelessWidget, Text, TextStyle, ValueListenableBuilder, ValueNotifier, VoidCallback, Widget;

import '../app_colors.dart';
import '../models/layer.dart';

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
      width: 140,
      padding: const EdgeInsets.all(4.0),
      color: whitecolor,
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
              ValueListenableBuilder<List<Layer>>(
                valueListenable: layersNotifier,
                builder: (context, layers, _) {
                  final isOnlyOneLayer = layers.length == 1;
                  return IconButton(
                    icon: Icon(
                      Icons.remove,
                      color: isOnlyOneLayer ? disablecolor : blackcolor,
                    ),
                    tooltip: 'Remove Layer',
                    // Disable onRemoveLayer when there's only 1 layer
                    onPressed: isOnlyOneLayer ? null : onRemoveLayer,
                  );
                },
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
                                  ? beigecolor
                                  : whitecolor,
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
                                        ? blackcolor
                                        : disablecolor,
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
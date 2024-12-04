import 'package:flutter/material.dart';

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
                        return GestureDetector(
                          onTap: () => onSelectLayer(index),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6.0, vertical: 6.0),
                            margin: const EdgeInsets.symmetric(vertical: 2.0),
                            decoration: BoxDecoration(
                              color: selectedLayerIndex == index
                                  ? Colors.orange
                                  : Colors.white,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Text(
                              layers[index].name,
                              style: const TextStyle(fontSize: 12.0),
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
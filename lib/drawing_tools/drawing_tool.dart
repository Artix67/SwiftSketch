import 'package:flutter/material.dart';

abstract class DrawingTool {
  // Called when the drawing gesture starts
  void onPanStart(Offset position, List<Offset?> points);

  // Called when the drawing gesture updates
  void onPanUpdate(Offset position, List<Offset?> points);

  // Called when the drawing gesture ends
  void onPanEnd(Offset position, List<Offset?> points);

  // Get the preview start point, if applicable
  Offset? get previewStart;

  // Get the preview current position, if applicable
  Offset? get previewEnd;

  // Method to set snap-to-grid behavior
  void setSnapToGrid(bool value);

  // Determines whether the tool should snap to the grid.
  bool shouldSnapToGrid() => true;
}
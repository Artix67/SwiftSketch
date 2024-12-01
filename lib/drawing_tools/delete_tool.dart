import 'dart:ui';
import 'drawing_tool.dart';
import '/drawing_shapes/drawing_shape.dart';

class DeleteTool implements DrawingTool {
  final List<DrawingShape> _shapes;
  final VoidCallback onShapeDeleted;

  DeleteTool(this._shapes, this.onShapeDeleted);

  @override
  void onPanStart(Offset position, List<Offset?> points) {}

  @override
  void onPanUpdate(Offset position, List<Offset?> points) {}

  @override
  void onPanEnd(Offset position, List<Offset?> points) {
    DrawingShape? shapeToDelete;
    for (DrawingShape shape in _shapes.reversed) {
      if (_intersectsPath(shape, position)) {
        shapeToDelete = shape;
        break;
      }
    }

    if (shapeToDelete != null) {
      _shapes.remove(shapeToDelete);
      onShapeDeleted();
    }
  }

  bool _intersectsPath(DrawingShape shape, Offset position) {
    final Path path = shape.path;

    // Create a stroked version of the path to represent the stroke area
    final PathMetrics pathMetrics = path.computeMetrics();
    for (PathMetric pathMetric in pathMetrics) {
      final Path strokedPath = pathMetric.extractPath(0, pathMetric.length).shift(Offset.zero);
      final Rect bounds = strokedPath.getBounds();

      // Expand the bounds slightly to account for the stroke width
      final Rect hitBox = bounds.inflate(shape.strokeWidth / 2);

      // Check if the position is within the hit box
      if (hitBox.contains(position)) {
        return true;
      }
    }

    const double proximityThreshold = 10.0;
    for (PathMetric pathMetric in pathMetrics) {
      Offset? nearestPoint = _getNearestPointOnPath(pathMetric, position);
      if (nearestPoint != null && (nearestPoint - position).distance <= proximityThreshold) {
        return true;
      }
    }
    return false;
  }

  Offset? _getNearestPointOnPath(PathMetric pathMetric, Offset position) {
    double minDistance = double.infinity;
    Offset? nearestPoint;

    for (double t = 0.0; t <= pathMetric.length; t += 1.0) {
      final Tangent? tangent = pathMetric.getTangentForOffset(t);
      if (tangent != null) {
        double distance = (tangent.position - position).distance;
        if (distance < minDistance) {
          minDistance = distance;
          nearestPoint = tangent.position;
        }
      }
    }

    return nearestPoint;
  }

  @override
  Offset? get previewStart => null;

  @override
  Offset? get previewEnd => null;

  @override
  void setSnapToGrid(bool value) {}

  @override
  bool shouldSnapToGrid() => false;
}
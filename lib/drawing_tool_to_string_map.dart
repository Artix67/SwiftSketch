
import '/drawing_tools/drawing_tool.dart';
import '/drawing_tools/freeform_tool.dart';
import '/drawing_tools/line_tool.dart';
import '/drawing_tools/circle_tool.dart';
import '/drawing_tools/rectangle_tool.dart';
import '/drawing_tools/triangle_tool.dart';
import '/drawing_tools/delete_tool.dart';

DrawingTool mapToolTypeToTool(String toolType) {
  switch (toolType) {
    case 'Freeform':
      return FreeformTool();
    case 'Line':
      return LineTool();
    case 'Circle':
      return CircleTool();
    case 'Rectangle':
      return RectangleTool();
    case 'Triangle':
      return TriangleTool();
    case 'Delete':
      return DeleteTool([], (){});
    default:
      throw Exception('Unknown toolType: $toolType');
  }
}
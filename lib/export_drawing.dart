import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

// StatefulWidget for exporting drawings.
class ExportDrawing extends StatefulWidget {
  // Constructor with 'key' initialized using the 'super' keyword for better parameter forwarding.
  const ExportDrawing({super.key});

  @override
  _ExportDrawingState createState() => _ExportDrawingState();
}

// Private State class for ExportDrawing widget managing the export process.
class _ExportDrawingState extends State<ExportDrawing> {
  // Document object from the PDF package to build the PDF.
  final pdf = pw.Document();
  // GlobalKey to reference the widget tree for capturing the drawing as an image.
  final GlobalKey globalKey = GlobalKey();

  // Asynchronous function to export the drawing content to a PDF file.
  Future<void> exportToPdf() async {
    // Get the render object from the global key and check if it's a RenderRepaintBoundary.
    final boundary = globalKey.currentContext?.findRenderObject();
    if (boundary is RenderRepaintBoundary) {
      // Convert the boundary to an image.
      var image = await boundary.toImage();
      // Convert the image to byte data in PNG format.
      ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);

      if (byteData != null) {
        // Convert the byte data to a Uint8List.
        Uint8List pngBytes = byteData.buffer.asUint8List();
        // Create a new PDF document.
        final pdf = pw.Document();
        // Add a new page to the PDF document with the captured image.
        pdf.addPage(pw.Page(
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Image(pw.MemoryImage(pngBytes)),
              );
            }
        ));

        // Get the directory path for storing the file.
        final String dir = (await getApplicationDocumentsDirectory()).path;
        // Create the full path for the new PDF file.
        final String path = '$dir/drawing.pdf';
        // Create a File object for the path and write the PDF data to the file.
        final File file = File(path);
        await file.writeAsBytes(await pdf.save());
        // I think this is where we should handle success and failure cases, let me know if you agree.
      } else {
        // Handle the case where byte data could not be retrieved.
        // I am not sure if we need a user-friendly error message here or not.
      }
    } else {
      // Handle the case where the render boundary is not available.
      // This is also might be a good place for an error message, let me know your thoughts.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Export Drawing'),
        actions: <Widget>[
          // IconButton to trigger the export to PDF function.
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: exportToPdf,
          )
        ],
      ),
      body: RepaintBoundary(
        key: globalKey,
        // The child of this RepaintBoundary should be the widget representing the drawing area.
        // TODO: Replace this container with the actual drawing widget.
        child: Container(),
      ),
    );
  }
}
// I believe this is the base structure, I cannot test it yet. If someone is
// is able to test and let me know that would be great!!
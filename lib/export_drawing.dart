import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
const Color dgreencolor = Color(0xFF181C14);
const Color lgreencolor = Color(0xFF697565);
const Color biegecolor = Color(0xFFECDFCC);
const Color redcolor = Color(0xFFAB3E2B);
const Color bluecolor = Color(0xFF11487A);
const Color blackcolor = Color(0xFF181818);
const Color midgreencolor = Color(0xFF3C3D37);
// Taylor - By commenting out a lot of this, I made the export function a public Utility.
// This is to make it easier to call on the drawscreen, specifically about drawing_canvas.

//Added this line just to be able to commit something

// // StatefulWidget for exporting drawings.
// class ExportDrawing extends StatefulWidget {
//   // Constructor with 'key' initialized using the 'super' keyword for better parameter forwarding.
//   const ExportDrawing({super.key});
//
//   @override
//   _ExportDrawingState createState() => _ExportDrawingState();
// }
//
// // Private State class for ExportDrawing widget managing the export process.
// class _ExportDrawingState extends State<ExportDrawing> {
//   // Document object from the PDF package to build the PDF.
//   final pdf = pw.Document();
//
//   // GlobalKey to reference the widget tree for capturing the drawing as an image.
//   final GlobalKey globalKey = GlobalKey();

  // Asynchronous function to export the drawing content to a PDF file.
  Future<void> exportToPdf(BuildContext context, GlobalKey globalKey, String name) async {
    try {
      // Get the render object from the global key and check if it's a RenderRepaintBoundary.
      final boundary = globalKey.currentContext?.findRenderObject();
      if (boundary is RenderRepaintBoundary) {
        // Convert the boundary to an image.
        var image = await boundary.toImage();
        // Convert the image to byte data in PNG format.
        ByteData? byteData =
            await image.toByteData(format: ImageByteFormat.png);

        if (byteData != null) {
          // Convert the byte data to a Uint8List.
          Uint8List pngBytes = byteData.buffer.asUint8List();
          // Create a new PDF document.
          final pdf = pw.Document();
          // Add a new page to the PDF document with the captured image.
          pdf.addPage(pw.Page(build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(pw.MemoryImage(pngBytes)),
            );
          }));

          //Taylor - Set directory as temporary
          final Directory tempDir = await getTemporaryDirectory();
          final String path = '${tempDir.path}/${name}.pdf';
          final File file = File(path);
          await file.writeAsBytes(await pdf.save());

          //Taylor - Added this for iPads, so the share sheet would pop-up in the center of the screen
          Rect _calculateCenteredRect(RenderBox box) {
            Offset topLeft = box.localToGlobal(Offset.zero);
            Size boxSize = box.size;

            double centerX = topLeft.dx + boxSize.width / 2;
            double centerY = topLeft.dy + boxSize.height / 2;

            double popoverWidth = 1;
            double popoverHeight = 1;

            return Rect.fromLTWH(
              centerX,
              centerY,
              popoverWidth,
              popoverHeight,
            );
          }

          // Taylor - Added this to allow users to chose there own destination.
          final XFile xfile = XFile(path);
          RenderBox? box = context.findRenderObject() as RenderBox?;
          await Share.shareXFiles(
            [xfile],
            text: 'Here is my drawing', // Optional text accompanying the shared file
            sharePositionOrigin: box != null
                ? _calculateCenteredRect(box)
                : Rect.fromLTWH(
              MediaQuery.of(context).size.width / 2,
              MediaQuery.of(context).size.height / 2,
              1,
              1,
            ),
          );

          // Taylor - Added success and failure messages.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Drawing exported successfully to $path')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to retrieve image data.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unable to capture drawing.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Export Drawing'),
  //       actions: <Widget>[
  //         // IconButton to trigger the export to PDF function.
  //         IconButton(
  //           icon: const Icon(Icons.save),
  //           onPressed: exportToPdf,
  //         )
  //       ],
  //     ),
  //     body: RepaintBoundary(
  //       key: globalKey,
  //       // The child of this RepaintBoundary should be the widget representing the drawing area.
  //       // TODO: Replace this container with the actual drawing widget.
  //       child: Container(),
  //     ),
  //   );
  // }
// }
// I believe this is the base structure, I cannot test it yet. If someone is
// is able to test and let me know that would be great!!

// import 'package:flutter/material.dart';
// import 'package:swift_sketch/screens/settingsscreen.dart';
// const Color dgreencolor = Color(0xFF181C14);
// const Color lgreencolor = Color(0xFF697565);
// const Color biegecolor = Color(0xFFECDFCC);
// const Color redcolor = Color(0xFFAB3E2B);
// const Color bluecolor = Color(0xFF11487A);
// const Color blackcolor = Color(0xFF181818);
// const Color midgreencolor = Color(0xFF3C3D37);
// const List<String> exportlist = <String>['PDF', 'JPEG', 'PNG'];
// const List<String> reslist = <String>['Low', 'Medium', 'High', 'Ultra'];
// const List<String> filenamelist = <String>['Date', ' Title', 'Custom'];
//
// class ExportSettingsScreen extends StatelessWidget{
//   const ExportSettingsScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         home: Scaffold(
//           backgroundColor: biegecolor,
//           appBar: AppBar(
//             centerTitle: true,
//             backgroundColor: biegecolor,
//             title: const Text('Export Settings'),
//             leading: IconButton(onPressed: (){
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context){
//                     return const SettingsScreen();
//                   })
//               );
//             },
//                 icon: const Icon(Icons.arrow_back)),
//           ),
//           body: Center(
//             child: Column(mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 const Text('Export Format: '),
//                 DropdownMenu(
//                   initialSelection: 'PDF',
//                     width: 150,
//                     dropdownMenuEntries: exportlist.map(
//                             (e) => DropdownMenuEntry(
//                                 value: e, label: e)
//                     ).toList(),
//                   onSelected: (value){
//                     debugPrint('Export Format: $value');
//                   },
//                 ),
//                 const SizedBox(height: 10,),
//                 const Text('Resolution Quality: '),
//                 DropdownMenu(
//                   initialSelection: 'High',
//                   width: 150,
//                   dropdownMenuEntries: reslist.map(
//                           (e) => DropdownMenuEntry(
//                           value: e, label: e)
//                   ).toList(),
//                   onSelected: (value){
//                     debugPrint('Resolution Quality: $value');
//                   },
//                 ),
//                 const SizedBox(height: 10,),
//                 const Text('File Naming'),
//                 DropdownMenu(
//                   initialSelection: 'Date',
//                   width: 150,
//                   dropdownMenuEntries: filenamelist.map(
//                           (e) => DropdownMenuEntry(
//                           value: e, label: e)
//                   ).toList(),
//                   onSelected: (value){
//                     debugPrint('File Naming: $value');
//                   },
//                 )
//
//               ],
//             ),
//           ),
//
//         )
//     );
//   }
// }


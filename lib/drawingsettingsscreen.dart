import 'package:flutter/material.dart';
import 'package:swift_sketch/settingsscreen.dart';

const List<String> unitlist = <String>['Metric', 'Imperial'];
const List<String> gridsensitivitylist = <String>['5px', '10px', '15px', '20px'];
const List<String> zoomlist = <String>['5', '10', '15', '20'];
const List<String> autosavelist = <String>['5 min', '10 min', '15 min', '20 min'];

class DrawingSettingsScreen extends StatelessWidget{
  const DrawingSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.orange[100],
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.orange[100],
            title: const Text('Drawing Settings'),
            leading: IconButton(onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context){
                    return const SettingsScreen();
                  })
              );
            },
                icon: const Icon(Icons.arrow_back)),
          ),
          body: Center(
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Unit of Measurement:'),
                DropdownMenu(
                  initialSelection: 'Metric',
                  width: 150,
                  dropdownMenuEntries: unitlist.map(
                          (e) => DropdownMenuEntry(
                          value: e, label: e)
                  ).toList(),
                  onSelected: (value){
                    debugPrint('Unit of Measurement: $value');
                  },
                ),
                const SizedBox(height: 10,),
                const Text('Snap to Grid Sensitivity:'),
                DropdownMenu(
                  initialSelection: '10px',
                  width: 150,
                  dropdownMenuEntries: gridsensitivitylist.map(
                          (e) => DropdownMenuEntry(
                          value: e, label: e)
                  ).toList(),
                  onSelected: (value){
                    debugPrint('Snap to Grid Sensitivity: $value');
                  },
                ),
                const SizedBox(height: 10,),
                const Text('Zoom Sensitivity:'),
                DropdownMenu(
                  initialSelection: '10',
                  width: 150,
                  dropdownMenuEntries: zoomlist.map(
                          (e) => DropdownMenuEntry(
                          value: e, label: e)
                  ).toList(),
                  onSelected: (value){
                    debugPrint('Zoom Sensitivity: $value');
                  },
                ),
                const SizedBox(height: 10,),
                const Text('Auto Save Frequency:'),
                DropdownMenu(
                  initialSelection: '5 min',
                  width: 150,
                  dropdownMenuEntries: autosavelist.map(
                          (e) => DropdownMenuEntry(
                          value: e, label: e)
                  ).toList(),
                  onSelected: (value){
                    debugPrint('Auto Save Frequency: $value');
                  },
                )

              ],
            ),
          ),

        )
    );
  }
}
import 'package:flutter/material.dart';
import 'package:swift_sketch/settingsscreen.dart';


const List<String> themelist = <String>['Light', 'Dark'];
const List<String> toolbarposlist = <String>['Top', 'Bottom', 'Left', 'Right'];
const List<String> finstsizelist = <String>['6', '8', '10', '12', '14', '16', '18'];
const List<String> gridsizelist = <String>['5', '10', '15', '20'];
const List<String> layerpresetslist = <String>['Layer 1', 'Layer 2', 'Layer 3', 'Layer 4', 'Layer 5', 'Layer 6', 'Layer 7', 'Layer 8','Layer 9', 'Layer 10'];

class AppSettingsScreen extends StatelessWidget{
  const AppSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.orange[100],
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.orange[100],
            title: const Text("App Settings"),
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
                const Text("Theme:"),
                DropdownMenu(
                  initialSelection: 'Light',
                  width: 150,
                  dropdownMenuEntries: themelist.map(
                          (e) => DropdownMenuEntry(
                          value: e, label: e)
                  ).toList(),
                  onSelected: (value){
                    debugPrint('Theme: $value');
                  },
                ),
                const SizedBox(height: 10,),
                const Text("Tool Bar Position:"),
                DropdownMenu(
                  initialSelection: 'Top',
                  width: 150,
                  dropdownMenuEntries: toolbarposlist.map(
                          (e) => DropdownMenuEntry(
                          value: e, label: e)
                  ).toList(),
                  onSelected: (value){
                    debugPrint('Tool Bar Position: $value');
                  },
                ),
                const SizedBox(height: 10,),
                const Text("Font Size:"),
                DropdownMenu(
                  initialSelection: '12',
                  width: 150,
                  dropdownMenuEntries: finstsizelist.map(
                          (e) => DropdownMenuEntry(
                          value: e, label: e)
                  ).toList(),
                  onSelected: (value){
                    debugPrint('Font Size: $value');
                  },
                ),
                const SizedBox(height: 10,),
                Text("Line Thickness:"),
                ConstrainedBox(
                    constraints: const BoxConstraints.expand(height: 10, width: 400),
                  child: LineThickness(),

                ),
                const SizedBox(height: 10,),
                const Text("Grid Size:"),
                DropdownMenu(
                  initialSelection: '10',
                  width: 150,
                  dropdownMenuEntries: gridsizelist.map(
                          (e) => DropdownMenuEntry(
                          value: e, label: e)
                  ).toList(),
                  onSelected: (value){
                    debugPrint('Grid Size: $value');
                  },
                ),
                const Text("Layer Presets:"),
                DropdownMenu(
                  initialSelection: 'Layer 1',
                  width: 150,
                  dropdownMenuEntries: layerpresetslist.map(
                          (e) => DropdownMenuEntry(
                          value: e, label: e)
                  ).toList(),
                  onSelected: (value){
                    debugPrint('Layer Presets: $value');
                  },
                ),
               const Text("Grid Visibility:"),
                const Enable(),
                const Text("Tips & Tutorials:"),
                const Enable(),
                const Text("App Updates:"),
                const Enable(),

              ],
            ),
          ),
        )
    );
  }
}



class Enable extends StatefulWidget {
  const Enable({super.key});

  @override
  State<Enable> createState() => _EnableState();
}

class _EnableState extends State<Enable> {
  bool light = true;

  @override
  Widget build(BuildContext context) {
    return Switch(
      // This bool value toggles the switch.
      value: light,
      activeColor: Colors.red,
      onChanged: (bool value) {
        // This is called when the user toggles the switch.
        setState(() {
          light = value;
        });
      },
    );
  }
}




class LineThickness extends StatefulWidget {
  const LineThickness({super.key});

  @override
  State<LineThickness> createState() => _LineThickness();
}

class _LineThickness extends State<LineThickness> {
  double _currentSliderValue = 0;

  @override
  Widget build(BuildContext context) {
    return Slider(
        value: _currentSliderValue,
        max: 100,
        divisions: 10,
        label: _currentSliderValue.round().toString(),
        onChanged: (double value) {
          setState(() {
            _currentSliderValue = value;
          });
        },
      );

  }
}

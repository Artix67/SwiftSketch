import 'package:flutter/material.dart';
import 'package:swift_sketch/settingsscreen.dart';


const List<String> themelist = <String>['Light', 'Dark'];
const List<String> toolbarposlist = <String>['Top', 'Bottom', 'Left', 'Right'];
const List<String> finstsizelist = <String>['6', '8', '10', '12', '14', '16', '18'];
const List<String> gridsizelist = <String>['5', '10', '15', '20'];
const List<String> layerpresetslist = <String>['Layer 1', 'Layer 2', 'Layer 3', 'Layer 4', 'Layer 5', 'Layer 6', 'Layer 7', 'Layer 8','Layer 9', 'Layer 10'];
const Color dgreencolor = Color(0xFF181C14);
const Color lgreencolor = Color(0xFF2C2C2C);
const Color biegecolor = Color(0xFF2C2C2C);
const Color redcolor = Color(0xFF2C2C2C);
class AppSettingsScreen extends StatelessWidget{
  const AppSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          resizeToAvoidBottomInset: false,
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
            child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[

                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.3,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(alignment: Alignment.centerRight,
                          width: 150,
                          height: 58,
                          child: const Text("Theme:"),
                      ),
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
                    ],
                  ),
                ),
                SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.3,
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(alignment: Alignment.centerRight,
                            width: 150,
                          height: 58,
                            child: const Text("Tool Bar Position:"),
                        ),
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
                      ],
                    ),
                ),
                SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.3,
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(alignment: Alignment.centerRight,
                            width: 150,
                          height: 58,
                            child: const Text("Font Size:"),
                        ),
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
                      ],
                    ),
                ),
                SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.3,
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(alignment: Alignment.centerRight,
                            width: 150,
                          height: 58,
                            child:  const Text("Line Thickness:"),
                        ),
                        Container(alignment: Alignment.centerRight,
                              height: 58,
                              width: 150,
                          child: LineThickness(),
                        ),
                      ],
                    ),
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.3,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(alignment: Alignment.centerRight,
                        width: 150,
                        height: 58,
                        child: const Text("Recent Tools:"),
                      ),
                       Container(
                        width: 150,
                         height: 58,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                            )
                        ),
                        child: const Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ImageIcon(AssetImage("icons/draw.png")),
                            ImageIcon(AssetImage("icons/line.png")),
                            ImageIcon(AssetImage("icons/square.png")),
                            ImageIcon(AssetImage("icons/freeformshapes.png")),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.3,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(alignment: Alignment.centerRight,
                        width: 150,
                        height: 58,
                        child: const Text("Default Colors:"),
                      ),
                       Container(
                        width: 150,
                         height: 58,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          )
                        ),
                        child: const Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.square),
                            Icon(Icons.square),
                            Icon(Icons.square),
                            Icon(Icons.square)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.3,
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(alignment: Alignment.centerRight,
                            width: 150,
                          height: 58,
                            child: const Text("Grid Size:"),
                        ),
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
                      ],
                    ),
                ),
                SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.3,
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(alignment: Alignment.centerRight,
                            width: 150,
                          height: 58,
                            child: const Text("Layer Presets:"),
                        ),
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
                      ],
                    ),
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.3,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(alignment: Alignment.centerRight,
                        width: 150,
                        height: 58,
                        child: const Text("Grid Visibility:"),
                      ),
                      Container(alignment: Alignment.center,
                        width: 150,
                        height: 58,
                        child: const Enable(),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.3,
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(alignment: Alignment.centerRight,
                            width: 150,
                          height: 58,
                            child: const Text("Tips & Tutorials:"),
                        ),
                        Container(alignment: Alignment.center,
                            width: 150,
                          height: 58,
                            child: const Enable(),
                        ),
                      ],
                    ),
                ),
                SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.3,
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(alignment: Alignment.centerRight,
                            width: 150,
                          height: 58,
                            child: const Text("App Updates:"),
                        ),
                        Container(alignment: Alignment.center,
                            width: 150,
                          height: 58,
                            child: Enable(),
                        ),
                      ],
                    ),
                ),
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
      activeColor: Colors.green[900],
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

    return SliderTheme(
        data: SliderThemeData(
          inactiveTrackColor: Colors.grey[500],
          activeTrackColor: Colors.green[900],
          thumbColor: redcolor,
          thumbShape:const  RoundSliderThumbShape(enabledThumbRadius: 6.0),
          overlayShape:const  RoundSliderOverlayShape(overlayRadius: 5.0),
          activeTickMarkColor: Colors.black,
          inactiveTickMarkColor: Colors.black,
          trackHeight: 5,
          valueIndicatorColor: Colors.black,
          valueIndicatorStrokeColor: Colors.green[900],
          valueIndicatorTextStyle:  TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.green[900],
          ),
        ),
        child: Slider.adaptive(
          value: _currentSliderValue,
          max: 100,
          divisions: 10,
          label: _currentSliderValue.toString(),
          onChanged: (double value) {
            setState(() {
              _currentSliderValue = value;
            });
          },
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:swift_sketch/settingsscreen.dart';
import 'DatabaseHelper.dart';
import 'FirebaseAuthService.dart';

const List<String> themelist = <String>['Light', 'Dark'];
const List<String> toolbarposlist = <String>['Top', 'Bottom', 'Left', 'Right'];
const List<String> finstsizelist = <String>['6', '8', '10', '12', '14', '16', '18'];
const List<String> gridsizelist = <String>['5', '10', '15', '20'];
const List<String> layerpresetslist = <String>['Layer 1', 'Layer 2', 'Layer 3', 'Layer 4', 'Layer 5', 'Layer 6', 'Layer 7', 'Layer 8','Layer 9', 'Layer 10'];

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  String _theme = 'Light';
  String _toolbarPosition = 'Top';
  String _fontSize = '12';
  String _gridSize = '10';
  String _layerPresets = 'Layer 1';
  bool _gridVisibility = true;
  bool _tipsTutorials = true;
  bool _appUpdates = true;
  double _lineThickness = 0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    final user = _authService.auth.currentUser;
    if (user != null) {
      final settings = await _dbHelper.getSettings(user.email!);
      if (settings != null) {
        setState(() {
          _theme = settings['theme'] ?? 'Light';
          _toolbarPosition = settings['toolbarPosition'] ?? 'Top';
          _fontSize = settings['fontSize'] ?? '12';
          _gridSize = settings['gridSize'] ?? '10';
          _layerPresets = settings['layerPresets'] ?? 'Layer 1';
          _gridVisibility = settings['gridVisibility'] == 1;
          _tipsTutorials = settings['tipsTutorials'] == 1;
          _appUpdates = settings['appUpdates'] == 1;
          _lineThickness = settings['lineThickness'] ?? 0.0;
        });
      }
    }
  }

  void _updateSettings() async {
    final user = _authService.auth.currentUser;
    if (user != null) {
      await _dbHelper.updateSettings({
        'userEmail': user.email,
        'theme': _theme,
        'toolbarPosition': _toolbarPosition,
        'fontSize': _fontSize,
        'gridSize': _gridSize,
        'layerPresets': _layerPresets,
        'gridVisibility': _gridVisibility ? 1 : 0,
        'tipsTutorials': _tipsTutorials ? 1 : 0,
        'appUpdates': _appUpdates ? 1 : 0,
        'lineThickness': _lineThickness,
      });
    }
  }

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
                initialSelection: _theme,
                width: 150,
                dropdownMenuEntries: themelist.map(
                        (e) => DropdownMenuEntry(
                        value: e, label: e)
                ).toList(),
                onSelected: (value){
                  setState(() {
                    _theme = value!;
                    _updateSettings();
                  });
                  debugPrint('Theme: $value');
                },
              ),
              const SizedBox(height: 10,),
              const Text("Tool Bar Position:"),
              DropdownMenu(
                initialSelection: _toolbarPosition,
                width: 150,
                dropdownMenuEntries: toolbarposlist.map(
                        (e) => DropdownMenuEntry(
                        value: e, label: e)
                ).toList(),
                onSelected: (value){
                  setState(() {
                    _toolbarPosition = value!;
                    _updateSettings();
                  });
                  debugPrint('Tool Bar Position: $value');
                },
              ),
              const SizedBox(height: 10,),
              const Text("Font Size:"),
              DropdownMenu(
                initialSelection: _fontSize,
                width: 150,
                dropdownMenuEntries: finstsizelist.map(
                        (e) => DropdownMenuEntry(
                        value: e, label: e)
                ).toList(),
                onSelected: (value){
                  setState(() {
                    _fontSize = value!;
                    _updateSettings();
                  });
                  debugPrint('Font Size: $value');
                },
              ),
              const SizedBox(height: 10,),
              const Text("Line Thickness:"),
              ConstrainedBox(
                constraints: const BoxConstraints.expand(height: 10, width: 400),
                child: LineThickness(
                  initialSliderValue: _lineThickness,
                  onChanged: (value) {
                    setState(() {
                      _lineThickness = value;
                      _updateSettings();
                    });
                  },
                ),
              ),
              const SizedBox(height: 10,),
              const Text("Grid Size:"),
              DropdownMenu(
                initialSelection: _gridSize,
                width: 150,
                dropdownMenuEntries: gridsizelist.map(
                        (e) => DropdownMenuEntry(
                        value: e, label: e)
                ).toList(),
                onSelected: (value){
                  setState(() {
                    _gridSize = value!;
                    _updateSettings();
                  });
                  debugPrint('Grid Size: $value');
                },
              ),
              const Text("Layer Presets:"),
              DropdownMenu(
                initialSelection: _layerPresets,
                width: 150,
                dropdownMenuEntries: layerpresetslist.map(
                        (e) => DropdownMenuEntry(
                        value: e, label: e)
                ).toList(),
                onSelected: (value){
                  setState(() {
                    _layerPresets = value!;
                    _updateSettings();
                  });
                  debugPrint('Layer Presets: $value');
                },
              ),
              const Text("Grid Visibility:"),
              Enable(
                initialSwitchValue: _gridVisibility,
                onChanged: (value) {
                  setState(() {
                    _gridVisibility = value;
                    _updateSettings();
                  });
                },
              ),
              const Text("Tips & Tutorials:"),
              Enable(
                initialSwitchValue: _tipsTutorials,
                onChanged: (value) {
                  setState(() {
                    _tipsTutorials = value;
                    _updateSettings();
                  });
                },
              ),
              const Text("App Updates:"),
              Enable(
                initialSwitchValue: _appUpdates,
                onChanged: (value) {
                  setState(() {
                    _appUpdates = value;
                    _updateSettings();
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Enable extends StatefulWidget {
  final bool initialSwitchValue;
  final ValueChanged<bool> onChanged;

  const Enable({super.key, required this.initialSwitchValue, required this.onChanged});

  @override
  State<Enable> createState() => _EnableState();
}

class _EnableState extends State<Enable> {
  late bool light;

  @override
  void initState() {
    super.initState();
    light = widget.initialSwitchValue;
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: light,
      activeColor: Colors.red,
      onChanged: (bool value) {
        setState(() {
          light = value;
          widget.onChanged(value);
        });
      },
    );
  }
}

class LineThickness extends StatefulWidget {
  final double initialSliderValue;
  final ValueChanged<double> onChanged;

  const LineThickness({super.key, required this.initialSliderValue, required this.onChanged});

  @override
  State<LineThickness> createState() => _LineThicknessState();
}

class _LineThicknessState extends State<LineThickness> {
  late double _currentSliderValue;

  @override
  void initState() {
    super.initState();
    _currentSliderValue = widget.initialSliderValue;
  }

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
          widget.onChanged(value);
        });
      },
    );
  }
}

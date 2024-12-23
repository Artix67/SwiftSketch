import 'package:flutter/material.dart';
import '/screens/settingsscreen.dart';
import '/FirebaseAuthService.dart';
import '/SettingsManager.dart';



const List<String> toolbarposlist = <String>['Top', 'Bottom', 'Left', 'Right'];
const List<String> gridsizelist = <String>['5', '10', '15', '20'];

const Color dgreencolor = Color(0xFF181C14);
const Color lgreencolor = Color(0xFF697565);
const Color biegecolor = Color(0xFFCBC2B4);
const Color redcolor = Color(0xFFAB3E2B);
const Color bluecolor = Color(0xFF11487A);
const Color blackcolor = Color(0xFF181818);
const Color midgreencolor = Color(0xFF3C3D37);
const Color whitecolor = Color(0xFFEEEEEE);


class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final SettingsManager _settingsManager = SettingsManager();

  String _toolbarPosition = 'Top';
  String _gridSize = '10';
  bool _gridVisibility = true;
  double _lineThickness = 0;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    final user = _authService.auth.currentUser;
    if (user != null) {
      final settings = await _settingsManager.loadUserSettings();
      if (settings.isNotEmpty) {
        setState(() {
          _toolbarPosition = settings['toolbarPosition'] ?? 'Top';
          _gridSize = settings['gridSize'] ?? '10';
          _gridVisibility = settings['gridVisibility'] == 1;
          _lineThickness = settings['lineThickness'] ?? 0.0;
        });
      }
    }
  }

  void _updateSettings(String key, dynamic value) async {
    final user = _authService.auth.currentUser;
    if (user != null) {
      await _settingsManager.updateUserSetting(key, value);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Settings updated successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: biegecolor,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: biegecolor,
          title: const Text("App Settings"),
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return const SettingsScreen();
                }),
              );
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // Toolbar Position Setting
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      width: 150,
                      height: 58,
                      child: const Text("Tool Bar Position:"),
                    ),
                    DropdownMenu(
                      initialSelection: _toolbarPosition,
                      width: 150,
                      dropdownMenuEntries: toolbarposlist.map(
                            (e) => DropdownMenuEntry(value: e, label: e),
                      ).toList(),
                      onSelected: (value) {
                        debugPrint('Tool Bar Position: $value');
                        setState(() {
                          _toolbarPosition = value!;
                          _updateSettings('toolbarPosition', value);
                        });
                      },
                    ),
                  ],
                ),
              ),

              // Line Thickness Setting
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      width: 150,
                      height: 58,
                      child: const Text("Line Thickness:"),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      height: 58,
                      width: 150,
                      child: LineThickness(
                        initialSliderValue: _lineThickness,
                        onChanged: (value) {
                          setState(() {
                            _lineThickness = value;
                            _updateSettings('lineThickness', value);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Grid Size Setting
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      width: 150,
                      height: 58,
                      child: const Text("Grid Size:"),
                    ),
                    DropdownMenu(
                      initialSelection: _gridSize,
                      width: 150,
                      dropdownMenuEntries: gridsizelist.map(
                            (e) => DropdownMenuEntry(value: e, label: e),
                      ).toList(),
                      onSelected: (value) {
                        debugPrint('Grid Size: $value');
                        setState(() {
                          _gridSize = value!;
                          _updateSettings('gridSize', value);
                        });
                      },
                    ),
                  ],
                ),
              ),

              // Grid Visibility Setting
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      width: 150,
                      height: 58,
                      child: const Text("Grid Visibility:"),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 150,
                      height: 58,
                      child: Enable(
                        initialSwitchValue: _gridVisibility,
                        onChanged: (value) {
                          setState(() {
                            _gridVisibility = value;
                            _updateSettings('gridVisibility', value ? 1 : 0);
                          });
                        },
                      ),
                    ),
                  ],
                ),
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

  const Enable({
    super.key,
    required this.initialSwitchValue,
    required this.onChanged,
  });

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
      activeColor: Colors.green[900],
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

  const LineThickness({
    super.key,
    required this.initialSliderValue,
    required this.onChanged,
  });

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
    return SliderTheme(
      data: SliderThemeData(
        inactiveTrackColor: Colors.grey[500],
        activeTrackColor: Colors.green[900],
        thumbColor: redcolor,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 5.0),
        activeTickMarkColor: Colors.black,
        inactiveTickMarkColor: Colors.black,
        trackHeight: 5,
        valueIndicatorColor: Colors.black,
        valueIndicatorStrokeColor: Colors.green[900],
        valueIndicatorTextStyle: TextStyle(
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
            widget.onChanged(value);
          });
        },
      ),
    );
  }
}
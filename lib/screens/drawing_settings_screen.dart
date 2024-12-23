import 'package:flutter/material.dart';
import '/screens/settingsscreen.dart';
import '/FirebaseAuthService.dart';
import '/FirestoreService.dart';
const Color dgreencolor = Color(0xFF181C14);
const Color lgreencolor = Color(0xFF697565);
const Color biegecolor = Color(0xFFECDFCC);
const Color redcolor = Color(0xFFAB3E2B);
const Color bluecolor = Color(0xFF11487A);
const Color blackcolor = Color(0xFF181818);
const Color midgreencolor = Color(0xFF3C3D37);
const List<String> unitlist = <String>['Metric', 'Imperial'];
const List<String> gridsensitivitylist = <String>['5px', '10px', '15px', '20px'];
const List<String> zoomlist = <String>['5', '10', '15', '20'];
const List<String> autosavelist = <String>['5 min', '10 min', '15 min', '20 min'];

class DrawingSettingsScreen extends StatefulWidget {
  const DrawingSettingsScreen({super.key});

  @override
  State<DrawingSettingsScreen> createState() => _DrawingSettingsScreenState();
}

class _DrawingSettingsScreenState extends State<DrawingSettingsScreen> {
  final FirebaseAuthService _authService = FirebaseAuthService();
  final FirestoreService _firestoreService = FirestoreService();

  // String _unitOfMeasurement = 'Metric';
  String _gridSensitivity = '10px';
  String _zoomSensitivity = '10';
  String _autoSaveFrequency = '5 min';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    final user = _authService.auth.currentUser;
    if (user != null) {
      final settings = await _firestoreService.getSettings(user.uid);
      if (settings != null) {
        setState(() {
          // _unitOfMeasurement = settings['unitOfMeasurement'] ?? 'Metric';
          _gridSensitivity = settings['gridSensitivity'] ?? '10px';
          _zoomSensitivity = settings['zoomSensitivity'] ?? '10';
          _autoSaveFrequency = settings['autoSaveFrequency'] ?? '5 min';
        });
      }
    }
  }

  void _updateSettings() async {
    final user = _authService.auth.currentUser;
    if (user != null) {
      await _firestoreService.updateSettings({
        'userUID': user.uid,
        // 'unitOfMeasurement': _unitOfMeasurement,
        'gridSensitivity': _gridSensitivity,
        'zoomSensitivity': _zoomSensitivity,
        'autoSaveFrequency': _autoSaveFrequency,
      });
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
          title: const Text('Drawing Settings'),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //TODO: Not a bad idea but not yet, reassess at your will
              // const Text('Unit of Measurement:'),
              // DropdownMenu(
              //   // initialSelection: _unitOfMeasurement,
              //   width: 150,
              //   dropdownMenuEntries: unitlist.map(
              //         (e) => DropdownMenuEntry(value: e, label: e),
              //   ).toList(),
              //   onSelected: (value) {
              //     setState(() {
              //       _unitOfMeasurement = value!;
              //       _updateSettings();
              //     });
              //     debugPrint('Unit of Measurement: $value');
              //   },
              // ),
              // const SizedBox(height: 10),

              //TODO: move to app settings?
              const Text('Snap to Grid Sensitivity:'),
              DropdownMenu(
                initialSelection: _gridSensitivity,
                width: 150,
                dropdownMenuEntries: gridsensitivitylist.map(
                      (e) => DropdownMenuEntry(value: e, label: e),
                ).toList(),
                onSelected: (value) {
                  setState(() {
                    _gridSensitivity = value!;
                    _updateSettings();
                  });
                  debugPrint('Snap to Grid Sensitivity: $value');
                },
              ),
              const SizedBox(height: 10),

              //TODO: move to app settings?
              const Text('Zoom Sensitivity:'),
              DropdownMenu(
                initialSelection: _zoomSensitivity,
                width: 150,
                dropdownMenuEntries: zoomlist.map(
                      (e) => DropdownMenuEntry(value: e, label: e),
                ).toList(),
                onSelected: (value) {
                  setState(() {
                    _zoomSensitivity = value!;
                    _updateSettings();
                  });
                  debugPrint('Zoom Sensitivity: $value');
                },
              ),
              const SizedBox(height: 10),
              // const Text('Auto Save Frequency:'),
              // DropdownMenu(
              //   initialSelection: _autoSaveFrequency,
              //   width: 150,
              //   dropdownMenuEntries: autosavelist.map(
              //         (e) => DropdownMenuEntry(value: e, label: e),
              //   ).toList(),
              //   onSelected: (value) {
              //     setState(() {
              //       _autoSaveFrequency = value!;
              //       _updateSettings();
              //     });
              //     debugPrint('Auto Save Frequency: $value');
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

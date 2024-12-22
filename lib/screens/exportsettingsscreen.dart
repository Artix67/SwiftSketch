import 'package:flutter/material.dart';
import 'package:swift_sketch/screens/settingsscreen.dart';


const List<String> exportlist = <String>['PDF', 'JPEG', 'PNG'];
const List<String> reslist = <String>['Low', 'Medium', 'High', 'Ultra'];
const List<String> filenamelist = <String>['Date', ' Title', 'Custom'];

class ExportSettingsScreen extends StatelessWidget{
  const ExportSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.orange[100],
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.orange[100],
            title: const Text('Export Settings'),
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
                const Text('Export Format: '),
                DropdownMenu(
                  initialSelection: 'PDF',
                    width: 150,
                    dropdownMenuEntries: exportlist.map(
                            (e) => DropdownMenuEntry(
                                value: e, label: e)
                    ).toList(),
                  onSelected: (value){
                    debugPrint('Export Format: $value');
                  },
                ),
                const SizedBox(height: 10,),
                const Text('Resolution Quality: '),
                DropdownMenu(
                  initialSelection: 'High',
                  width: 150,
                  dropdownMenuEntries: reslist.map(
                          (e) => DropdownMenuEntry(
                          value: e, label: e)
                  ).toList(),
                  onSelected: (value){
                    debugPrint('Resolution Quality: $value');
                  },
                ),
                const SizedBox(height: 10,),
                const Text('File Naming'),
                DropdownMenu(
                  initialSelection: 'Date',
                  width: 150,
                  dropdownMenuEntries: filenamelist.map(
                          (e) => DropdownMenuEntry(
                          value: e, label: e)
                  ).toList(),
                  onSelected: (value){
                    debugPrint('File Naming: $value');
                  },
                )
                
              ],
            ),
          ),

        )
    );
  }
}


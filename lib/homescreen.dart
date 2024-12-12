import 'package:flutter/material.dart';
import 'package:swift_sketch/drawscreen.dart';
import 'package:swift_sketch/settingsscreen.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(
                backgroundColor: Colors.orange[100],
                actions: <Widget>[
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context){
                              return const SettingsScreen();
                            })
                        );
                        },
                      tooltip: 'Settings',
                      icon: const Icon(Icons.settings)

                      )
                    ]
                ),
          body: Center(
            child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context){
                        return const Drawscreen();
                      })
                  );
                },
                child: const Text('New Project')
            ),
          ),

        )
    );
  }
}
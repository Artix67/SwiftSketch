import 'package:flutter/material.dart';
import 'package:swift_sketch/settingsscreen.dart';

class PrivacySecurityScreen extends StatelessWidget{
  const PrivacySecurityScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.orange[100],
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.orange[100],
            title: const Text('Privacy and Security'),
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
          body: const Center(
            child: Row( mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Biometric Authentication: "),
                Enable(),
              ],
            )
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





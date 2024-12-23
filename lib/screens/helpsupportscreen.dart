import 'package:flutter/material.dart';
import 'package:swift_sketch/screens/settingsscreen.dart';
const Color dgreencolor = Color(0xFF181C14);
const Color lgreencolor = Color(0xFF697565);
const Color biegecolor = Color(0xFFECDFCC);
const Color redcolor = Color(0xFFAB3E2B);
const Color bluecolor = Color(0xFF11487A);
const Color blackcolor = Color(0xFF181818);
const Color midgreencolor = Color(0xFF3C3D37);
class HelpSupportScreen extends StatelessWidget{
  const HelpSupportScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          backgroundColor: biegecolor,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: biegecolor,
            title: const Text('Help and Support'),
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
              children: [
                OutlinedButton(onPressed: (){},
                    style: OutlinedButton.styleFrom(minimumSize: const Size(200, 50)),
                    child: const Text("User Guide")),
                const SizedBox(height: 10),
                OutlinedButton(onPressed: (){},
                    style: OutlinedButton.styleFrom(minimumSize: const Size(200, 50)),
                    child: const Text("Contact Support")),
                const SizedBox(height: 10),

                const Text("App Version 1.01"),
                  ],
            ),
          ),
        )
    );
  }
}


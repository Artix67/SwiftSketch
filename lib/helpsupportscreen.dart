import 'package:flutter/material.dart';
import 'package:swift_sketch/settingsscreen.dart';

class HelpSupportScreen extends StatelessWidget{
  const HelpSupportScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.orange[100],
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.orange[100],
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


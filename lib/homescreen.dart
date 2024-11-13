import 'package:flutter/material.dart';
import 'package:swift_sketch/drawscreen.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({Key? key}) : super (key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Center(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(minimumSize: const Size(200, 50)),
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context){
                          return Drawscreen();
                        })
                    );
                  },
                  child: Text("New project"),
                )
            )
        )
    );
  }
}
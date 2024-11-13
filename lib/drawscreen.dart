import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:swift_sketch/drawing_canvas.dart';
import 'package:swift_sketch/homescreen.dart';

class Drawscreen extends StatefulWidget{
  const Drawscreen({super.key});

  @override
  State<Drawscreen> createState() => _Drawscreen();
}

class _Drawscreen extends State<Drawscreen>{

  final _offsets = <Offset>[];
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
                        return HomeScreen();
                      })
                  );
                },
                icon: Icon(Icons.delete),
              ),
            ],
          ),

          body: DrawingCanvas(),

          ));
  }
}



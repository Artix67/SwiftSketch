import 'package:flutter/material.dart';

import 'homescreen.dart';

class LoginScreen extends StatelessWidget{
  const LoginScreen({super.key});

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
                          return HomeScreen();
                        })
                    );
                  },
                  child: Text("Login"),
                )
            )
        )
    );
  }
}
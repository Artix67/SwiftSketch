import 'package:flutter/material.dart';
import 'package:swift_sketch/loginscreen.dart';

class CreateAccountScreen extends StatelessWidget{
  const CreateAccountScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
           body: Center(
             child: ConstrainedBox(
                 constraints: const BoxConstraints.expand(height: 300, width: 300),
                 child: Column(
                   children: [
                     ElevatedButton(onPressed: (){
                       Navigator.push(
                           context,
                           MaterialPageRoute(builder: (context){
                             return const LoginScreen();
                           })
                       );
                     },
                         child: const Text('Back')),
                     const TextField(
                       decoration:  InputDecoration(
                         labelText: 'Email',
                       ),
                     ),
                     const TextField(
                       decoration:  InputDecoration(
                         labelText: 'Password',
                       ),
                       obscureText: true,
                     ),
                     ElevatedButton(
                       onPressed: (){},
                       child: const Text('Create Account'),
                     ),
                   ],
                 ),

             ),
           ),
        )
    );
  }
}
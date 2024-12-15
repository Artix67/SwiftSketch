import 'package:flutter/material.dart';
import 'package:swift_sketch/settingsscreen.dart';

class AccountSettingsScreen extends StatelessWidget{
  const AccountSettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            backgroundColor: Colors.orange[100],
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.orange[100],
                title: const Text('Account Settings'),
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
            child: ConstrainedBox(
              constraints: const BoxConstraints.expand(height: 500, width: 500),
              child:  SizedBox(
              child: Column(
                children: [
                  const Icon(
                      Icons.verified_user,
                      color: Colors.black,
                      size: 24.0
                  ),
                  const SizedBox(height: 10),
                  const SelectionContainer.disabled(
                      child: Text('First Name:')
                  ),
                  const TextField(
                    decoration: InputDecoration(
                        hintText: 'First Name'
                    ),
                  ),
                  const SizedBox(height: 10),
                  const SelectionContainer.disabled(
                      child: Text('Last Name:')
                  ),
                  const TextField(
                    decoration: InputDecoration(
                        hintText: 'Last Name'
                    ),
                  ),
                  const SizedBox(height: 10),
                  const SelectionContainer.disabled(
                      child: Text('Email Address:')
                  ),
                  const TextField(
                    decoration: InputDecoration(
                        hintText: 'Email Address'
                    ),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(minimumSize: const Size(200, 50)),
                      onPressed: (){
                      },
                      child: const Text("Delete Account")),
                  const SizedBox(height: 10),
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(minimumSize: const Size(200, 50)),
                      onPressed: (){
                      },
                      child: const Text("Change password")),
                ],
              ),
            )
          ),
          )
        )
    );
  }
}






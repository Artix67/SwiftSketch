import 'package:flutter/material.dart';
import 'package:swift_sketch/accountsettingsscreen.dart';
import 'package:swift_sketch/appsettingsscreen.dart';
import 'package:swift_sketch/drawingsettingsscreen.dart';
import 'package:swift_sketch/exportsettingsscreen.dart';
import 'package:swift_sketch/helpsupportscreen.dart';
import 'package:swift_sketch/homescreen.dart';
import 'package:swift_sketch/loginscreen.dart';
import 'package:swift_sketch/privacysecurityscreen.dart';

class SettingsScreen extends StatelessWidget{
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.orange[100],
            appBar: AppBar(
              backgroundColor: Colors.orange[100],
              centerTitle: true,
              title: const Text('Settings'),
              leading: IconButton(onPressed: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context){
                      return const HomeScreen();
                    })
                );
              },
                  icon: const Icon(Icons.arrow_back)),
            ),
            body: Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints.expand(height: 500, width: 350),
                  child: SizedBox(
                    child: Column(
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(minimumSize: const Size(200, 50)),
                          onPressed: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context){
                                  return const AccountSettingsScreen();
                                })
                            );
                          },
                          child: const Text("Account Settings"),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(minimumSize: const Size(200, 50)),
                          onPressed: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context){
                                  return const AppSettingsScreen();
                                })
                            );
                          },
                          child: const Text("App Settings"),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(minimumSize: const Size(200, 50)),
                          onPressed: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context){
                                  return const DrawingSettingsScreen();
                                })
                            );
                          },
                          child: const Text("Drawing Settings"),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(minimumSize: const Size(200, 50)),
                          onPressed: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context){
                                  return const ExportSettingsScreen();
                                })
                            );
                          },
                          child: const Text("Export Settings"),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(minimumSize: const Size(200, 50)),
                          onPressed: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context){
                                  return const PrivacySecurityScreen();
                                })
                            );
                          },
                          child: const Text("Privacy & Security"),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(minimumSize: const Size(200, 50)),
                          onPressed: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context){
                                  return const HelpSupportScreen();
                                })
                            );
                          },
                          child: const Text("Help & Support"),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(minimumSize: const Size(200, 50)),
                          onPressed: (){
                            Navigator.push(                                 //This will need to be changed to Navigator.pushNamedAndRemoveUntil(context, ## your routename here ##, (_) => false);
                                context,                                    //This will make it so that since were logging out the user can never return to this screen completely emptying the
                                MaterialPageRoute(builder: (context){       //navigator stack
                                  return const LoginScreen();
                                })
                            );
                          },
                          child: const Text("Log Out"),
                        )
                      ],
                    )
                  ),
                )
            )
        )
    );
  }
}
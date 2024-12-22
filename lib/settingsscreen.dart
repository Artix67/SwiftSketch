import 'package:flutter/material.dart';
import 'package:swift_sketch/accountsettingsscreen.dart';
import 'package:swift_sketch/appsettingsscreen.dart';
import 'package:swift_sketch/drawingsettingsscreen.dart';
import 'package:swift_sketch/exportsettingsscreen.dart';
import 'package:swift_sketch/helpsupportscreen.dart';
import 'package:swift_sketch/homescreen.dart';
import 'package:swift_sketch/loginscreen.dart';
const Color dgreencolor = Color(0xFF181C14);
const Color lgreencolor = Color(0xFF697565);
const Color biegecolor = Color(0xFFECDFCC);
const Color redcolor = Color(0xFFAB3E2B);
class SettingsScreen extends StatelessWidget{
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.orange[100],
            resizeToAvoidBottomInset: false,
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(150),
                child: AppBar(
                  backgroundColor: Colors.orange[100],
                  centerTitle: true,
                  flexibleSpace: Container(
                    height: 200,
                    child: Image.asset('images/SSLogo.png',
                      height: 200,
                      width: 200,
                    ),
                  ),
                  leading: IconButton(onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context){
                          return const HomeScreen();
                        })
                    );
                  },
                      icon: const Icon(Icons.arrow_back)),
                )
            ),
            body: Center(
                  child: SizedBox(
                    width: 350,
                    child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[ 
                        OutlinedButton(
                          style: ButtonStyle(minimumSize:  WidgetStateProperty.all(const Size(200, 50)), backgroundColor: WidgetStateProperty.all(lgreencolor) ),
                          onPressed: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context){
                                  return const AccountSettingsScreen();
                                })
                            );
                          },
                          child: const Text("Account Settings", style: TextStyle(
                            color: biegecolor,
                          ),),
                        ),
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
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(minimumSize: const Size(200, 50)),
                          onPressed: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context){
                                  return const LoginScreen();
                                })
                            );
                          },
                          child: const Text("Log Out"),
                        )
                      ],
                    )

                )
            )
        )
    );
  }
}

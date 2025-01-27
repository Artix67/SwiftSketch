import 'package:flutter/material.dart';

import 'account_settings_screen.dart';
import 'app_settings_screen.dart';
import 'loginscreen.dart';

const Color dgreencolor = Color(0xFF181C14);
const Color lgreencolor = Color(0xFF697565);
const Color biegecolor = Color(0xFFCBC2B4);
const Color redcolor = Color(0xFFAB3E2B);
const Color bluecolor = Color(0xFF11487A);
const Color blackcolor = Color(0xFF181818);
const Color midgreencolor = Color(0xFF3C3D37);

class SettingsDrawer extends StatelessWidget{
  const SettingsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: biegecolor,
      child: Column( crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildHeader(),
              const SizedBox(height: 20,),
              OutlinedButton(
                style: OutlinedButton.styleFrom(minimumSize: const Size(200, 50),
                    backgroundColor: lgreencolor,
                    foregroundColor: biegecolor),
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
          const Divider(
            height: 50,
            color: Colors.black,
            thickness: 1,
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(minimumSize: const Size(200, 50),
                backgroundColor: lgreencolor,
                foregroundColor: biegecolor),
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
      ),
    );
  }


}
Widget buildHeader() => InkWell(
  child: Container(
    padding: const EdgeInsets.fromLTRB(70, 20, 70, 20),
    color: lgreencolor,
    child: Column(crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset("icons/userprofile.png",
        height: 100,
        width: 100,),
        Row(crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("First Name",
            style: TextStyle(
              fontSize: 12
            ),),
            SizedBox(width: 20,),
            Text("Last Name",
            style: TextStyle(
              fontSize: 12
            ),),
          ],
        )
      ],
    ),

  ),
);
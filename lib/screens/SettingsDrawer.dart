import 'package:flutter/material.dart';

import '../app_colors.dart';
import 'account_settings_screen.dart';
import 'app_settings_screen.dart';
import 'loginscreen.dart';

class SettingsDrawer extends StatelessWidget{
  const SettingsDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: beigecolor,
      child: Column( crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildHeader(),
              const SizedBox(height: 20,),
              OutlinedButton(
                style: OutlinedButton.styleFrom(minimumSize: const Size(200, 50),
                    backgroundColor: lgreencolor,
                    foregroundColor: blackcolor),
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
            color: blackcolor,
            thickness: 1,
          ),
          TextButton(
            onPressed: (){
              Navigator.push(                                 //This will need to be changed to Navigator.pushNamedAndRemoveUntil(context, ## your routename here ##, (_) => false);
                  context,                                    //This will make it so that since were logging out the user can never return to this screen completely emptying the
                  MaterialPageRoute(builder: (context){       //navigator stack
                    return const LoginScreen();
                  })
              );
            },
            child: const Text(
              'Log Out',
              style: TextStyle(
                color: redcolor,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }


}
Widget buildHeader() => InkWell(
  child: Container(
    padding: const EdgeInsets.fromLTRB(70, 20, 70, 20),
    color: blackcolor,
    child: Column(crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset("icons/userprofile.png",
        height: 100,
        width: 100,),
        const Row(crossAxisAlignment: CrossAxisAlignment.center,
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
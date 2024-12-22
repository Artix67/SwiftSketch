import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swift_sketch/drawscreen.dart';
import 'package:swift_sketch/settingsscreen.dart';
const Color mcolor = Color(0xFF2C2C2C);
class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.orange[100],
            appBar: AppBar(
                backgroundColor: Colors.orange[100],

                // title: const Text("SwiftSketch"),
                // elevation: 0, //adds shadow to appbar
                // titleSpacing: 20,
                // titleTextStyle: const TextStyle(
                //   fontSize: 41,
                //   color: mcolor,
                // ),
                actions: <Widget>[
                  Container(
                    decoration: const BoxDecoration(

                    ),
                    child: Row(
                      children: [
                        SizedBox(width: 20,),
                        Image.asset('images/SSLogo.png',
                          height: 90,
                          width: 90,
                        ),
                        SizedBox(width: 20,),
                        Text("Swift Sketch",
                        style: TextStyle(fontSize: 32),
                        ),
                        SizedBox(width: MediaQuery.sizeOf(context).width * 0.35,),
                        SizedBox(
                            height: 70,
                            width: 400,
                            child: Column(
                              children: [
                                SearchBar(),
                              ],
                            )
                        ),
                        const SizedBox(width: 30),
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context){
                                    return const SettingsScreen();
                                  })
                              );
                            },
                            tooltip: 'Settings',
                            icon: const ImageIcon(AssetImage("icons/settings.png"))
                        ),
                        const SizedBox(width: 19,)
                      ],
                    ),
                  )
                    ]
                ),
          body: Column(
            children: <Widget>[
              Padding(padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height * .05,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2
                  )
                ),
                child: Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  children: [
                    Text("Project Name"),
                    SizedBox(width: MediaQuery.sizeOf(context).width * 0.55),
                    Text("Date"),
                  ],
                ),)
              )
              ),
              // Expanded(
              //   child: StreamBuilder(
              //       stream: FirebaseFirestore.instance.collection('users').snapshots(),
              //       builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              //         if(snapshot.hasData) {
              //           return ListView.builder(
              //             itemCount: snapshot.data.docs.length,
              //               itemBuilder: (context, index) => Padding(
              //                   padding: const EdgeInsets.all(8),
              //                 child: Container(
              //                   height: 60,
              //                   decoration: BoxDecoration(
              //                     color: Colors.grey,
              //                   ),
              //                   child: Row(
              //                     children: [
              //                       SizedBox(
              //                         width: 10,
              //                       ),
              //                       Container(
              //                         width: 160,
              //                         child: Text(snapshot.data.docs[index]["name"]),
              //                       ),
              //                       Container(
              //                         width: 140,
              //                         child: Text(snapshot.data.docs[index]["date"]),
              //                       ),
              //                       IconButton(onPressed: (){},
              //                           icon: const ImageIcon(AssetImage("icons/draw.png")),
              //                       ),
              //                       IconButton(onPressed: (){},
              //                         icon: const ImageIcon(AssetImage("icons/export2.png")),
              //                       ),
              //                       IconButton(onPressed: (){},
              //                         icon: Icon(Icons.delete),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               )
              //           );
              //         } else {
              //           return Container();
              //         }
              //       }
              //   ),
              // ),
              Expanded(
                  child: Align(
                    alignment: FractionalOffset.bottomRight,
                    child: Padding(padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context){
                                return const Drawscreen();
                              })
                          );
                        },
                        child: const Text('New Project')
                    ),
                    )
              )
              ),

            ],
          )

        )
    );
  }
}


class SearchBar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const TextField(
        style: TextStyle(fontSize: 14, ),
        decoration: InputDecoration(
        hintText: 'Search Projects',
        border: OutlineInputBorder(),
        suffixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}
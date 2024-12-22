import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swift_sketch/drawscreen.dart';
import 'package:swift_sketch/settingsscreen.dart';
const Color mcolor = Color(0xFF2C2C2C);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.orange[100],
        appBar: AppBar(
          backgroundColor: Colors.orange[100],
          actions: <Widget>[
            Container(
              decoration: const BoxDecoration(),
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  Image.asset(
                    'images/SSLogo.png',
                    height: 90,
                    width: 90,
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    "Swift Sketch",
                    style: TextStyle(fontSize: 32),
                  ),
                  SizedBox(width: MediaQuery.sizeOf(context).width * 0.35),
                  SizedBox(
                    height: 70,
                    width: 400,
                    child: Column(
                      children: [
                        SearchBar(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 30),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return const SettingsScreen();
                        }),
                      );
                    },
                    tooltip: 'Settings',
                    icon: const ImageIcon(AssetImage("icons/settings.png")),
                  ),
                  const SizedBox(width: 19),
                ],
              ),
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height * .05,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    children: [
                      const Text("Project Name"),
                      SizedBox(width: MediaQuery.sizeOf(context).width * 0.55),
                      const Text("Date"),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('projects').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var project = snapshot.data!.docs[index];
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                Container(
                                  width: 160,
                                  child: Text(project['name']),
                                ),
                                Container(
                                  width: 140,
                                  child: Text(project['date']),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return const Drawscreen();
                                        },
                                      ),
                                    );
                                  },
                                  icon: const ImageIcon(AssetImage("icons/draw.png")),
                                ),
                                IconButton(
                                  onPressed: () {
                                    // Implement export functionality here
                                  },
                                  icon: const ImageIcon(AssetImage("icons/export2.png")),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('projects')
                                        .doc(project.id)
                                        .delete();
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return const Drawscreen();
                        }),
                      );
                    },
                    child: const Text('New Project'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const TextField(
        style: TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search Projects',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.search),
        ),
      ),
    );
  }
}
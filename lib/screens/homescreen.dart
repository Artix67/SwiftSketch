import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '/screens/draw_screen.dart';
import 'package:swift_sketch/screens/settingsscreen.dart';
import '/FirebaseAuthService.dart';

const Color mcolor = Color(0xFF2C2C2C);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  final FirebaseAuthService _authService = FirebaseAuthService(); // Initialize the auth service

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _createNewProject() async {
    String projectName = await _showProjectNameDialog(context);
    if (projectName.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return Drawscreen(projectName: projectName);
        }),
      );
    }
  }

  Future<String> _showProjectNameDialog(BuildContext context) async {
    TextEditingController _nameController = TextEditingController();

    return await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Project Name'),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: 'Project Name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, '');
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, _nameController.text);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    ) ?? '';
  }

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
                        SearchBar(onSearchChanged: _updateSearchQuery),
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
                stream: FirebaseFirestore.instance
                    .collection('projects')
                    .where('userUID', isEqualTo: _authService.auth.currentUser?.uid) // Filter by the current user's UID
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    debugPrint('Error: ${snapshot.error}');
                    return const Center(child: Text('Error connecting to Firestore.'));
                  }
                  if (snapshot.hasData) {
                    var projects = snapshot.data!.docs;
                    if (_searchQuery.isNotEmpty) {
                      projects = projects.where((project) {
                        return project['name']
                            .toString()
                            .toLowerCase()
                            .contains(_searchQuery.toLowerCase());
                      }).toList();
                    }
                    if (projects.isEmpty) {
                      return const Center(child: Text('No projects found.'));
                    }
                    return ListView.builder(
                      itemCount: projects.length,
                      itemBuilder: (context, index) {
                        var project = projects[index];
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
                                          return Drawscreen(projectName: project['name']); // Correctly reference Drawscreen with projectName
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
                    return const Center(child: Text('No projects yet created.'));
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
                    onPressed: _createNewProject,
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
  final Function(String) onSearchChanged;

  const SearchBar({required this.onSearchChanged, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        style: const TextStyle(fontSize: 14),
        decoration: const InputDecoration(
          hintText: 'Search Projects',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.search),
        ),
        onChanged: onSearchChanged,
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '/screens/draw_screen.dart';
import 'package:swift_sketch/screens/settingsscreen.dart';
import '/FirebaseAuthService.dart';
import 'package:intl/intl.dart';

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
          return Drawscreen(projectName: projectName, exportImmediately: false, isGuest: false,);
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

  String formatDateTime(String dateTime) {
    try {
      final DateTime parsedDateTime = DateTime.parse(dateTime);
      final DateFormat formatter = DateFormat('MMMM d, y \'at\' h:mm a'); // AM/PM format
      return formatter.format(parsedDateTime);
    } catch (e) {
      return dateTime; // Fallback in case of an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.orange[100],
        appBar: AppBar(
          backgroundColor: Colors.orange[100],
          title: Row(
            children: [
              Row(
                children: [
                  const SizedBox(width: 20),
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Image.asset(
                      'images/SSLogo.png',
                      height: 40,
                      width: 40,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Swift Sketch",
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
              const Spacer(),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 40,
                      width: 300,
                      child: SearchBar(onSearchChanged: _updateSearchQuery),
                    ),
                    const SizedBox(width: 20),
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
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .055,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    children: [
                      const Text("Project Name"),
                      const Spacer(),
                      const Text("Date"),
                      const Spacer(),
                      const Text("Actions")
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('projects')
                    .where('userUID',
                    isEqualTo: _authService.auth.currentUser?.uid) // Filter by the current user's UID
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
                          padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white60,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 10),
                                Container(
                                  width: 250,
                                  child: Text(project['name']),
                                ),
                                const Spacer(),
                                Container(
                                  width: 250,
                                  child: Text(
                                    formatDateTime(project['date']), // Call the formatting function here
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return Drawscreen(
                                              projectName: project['name'],
                                            exportImmediately: false,
                                            isGuest: false,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  icon: const ImageIcon(AssetImage("icons/draw.png")),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return Drawscreen(
                                            projectName: project['name'],
                                            exportImmediately: true,
                                            isGuest: false,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  icon: const ImageIcon(AssetImage("icons/export2.png")),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    final bool confirmDelete = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Delete Project'),
                                          content: const Text('Are you sure you want to delete this project? This action cannot be undone.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(false); // User chose not to delete
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(true); // User confirmed deletion
                                              },
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    if (confirmDelete == true) {
                                      await FirebaseFirestore.instance
                                          .collection('projects')
                                          .doc(project.id)
                                          .delete();
                                    }
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
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: _createNewProject,
                  child: const Text('New Project'),
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
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        style: const TextStyle(fontSize: 14, color: Colors.black),
        textAlignVertical: TextAlignVertical.center, // Ensures vertical centering
        decoration: const InputDecoration(
          hintText: 'Search Projects',
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          isDense: true, // Reduces the default internal padding
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8), // Adjusts vertical padding
        ),
        onChanged: onSearchChanged,
      ),
    );
  }
}

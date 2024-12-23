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

  String formatDateTime(String dateTime) {
    try {
      final DateTime parsedDateTime = DateTime.parse(dateTime);

      // Get date components
      final String month = _getMonthName(parsedDateTime.month);
      final String day = parsedDateTime.day.toString();
      final String year = parsedDateTime.year.toString();

      // Get time components
      int hour = parsedDateTime.hour;
      final String minute = parsedDateTime.minute.toString().padLeft(2, '0');
      final String period = hour >= 12 ? 'PM' : 'AM';

      // Convert hour to 12-hour format
      hour = hour % 12 == 0 ? 12 : hour % 12;

      // Create a formatted string: "December 22, 2024 at 2:30 PM"
      return '$month $day, $year at $hour:$minute $period';
    } catch (e) {
      return dateTime; // Fallback in case of an error
    }
  }

  String _getMonthName(int month) {
    const List<String> months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
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
              // Left section (logo and text)
              Row(
                children: [
                  const SizedBox(width: 20),
                  FittedBox(
                    fit: BoxFit.contain,
                    child: Image.asset(
                      'images/SSLogo.png',
                      height: 40, // Adjust size as needed
                      width: 40,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Swift Sketch",
                    style: TextStyle(fontSize: 24), // Adjust font size as needed
                  ),
                ],
              ),
              // Spacer to push the right section to the end
              const Spacer(),
              // Right section (search bar and settings)
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end, // Align widgets to the right
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
                height: MediaQuery.of(context).size.height * .05,
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
                      const Spacer(),
                      const Text("Date"),
                      const Spacer(),
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
                          padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey,
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
                                              projectName: project['name']);
                                        },
                                      ),
                                    );
                                  },
                                  icon: const ImageIcon(AssetImage("icons/draw.png")),
                                ),
                                IconButton(
                                  onPressed: () {
                                    //TODO: ADD EXPORT FUNCTION HERE
                                  },
                                  icon: const ImageIcon(AssetImage("icons/export2.png")),
                                ),
                                // TODO: ADD DELETION ALERT, ALLOW USER TO CONFIRM BEFORE DELETING
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

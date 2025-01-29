import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swift_sketch/screens/account_settings_screen.dart';
import '../app_colors.dart';
import '/screens/draw_screen.dart';
import 'package:swift_sketch/screens/SettingsDrawer.dart';
import '/FirebaseAuthService.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _HomeScreenState extends State<HomeScreen> {
  int _projectCount = 0;
  String _searchQuery = '';
  final FirebaseAuthService _authService =
      FirebaseAuthService(); // Initialize the auth service

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
          return Drawscreen(
            projectName: projectName,
            exportImmediately: false,
            isGuest: false,
          );
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
              content: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: whitecolor,
                  border: Border.all(
                    color: blackcolor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: TextField(
                  controller: _nameController,
                  style: const TextStyle(fontSize: 14, color: blackcolor),
                  textAlignVertical: TextAlignVertical.center,
                  obscureText: false,
                  decoration: const InputDecoration(
                    hintText: "Enter project name",
                    hintStyle: TextStyle(color: placeholdercolor),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                ),
              ),
              backgroundColor: beigecolor,
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: lgreycolor,
                        foregroundColor: blackcolor,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, '');
                      },
                      child: const Text('Cancel'),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: lgreencolor,
                        foregroundColor: blackcolor,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, _nameController.text);
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ],
            );
          },
        ) ??
        '';
  }

  String formatDateTime(String dateTime) {
    try {
      final DateTime parsedDateTime = DateTime.parse(dateTime);
      final DateFormat formatter =
          DateFormat('MMMM d, y \'at\' h:mm a'); // AM/PM format
      return formatter.format(parsedDateTime);
    } catch (e) {
      return dateTime; // Fallback in case of an error
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool pinnedMode = _projectCount >= 11;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: beigecolor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: beigecolor,
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
                  //TODO: SEARCH BAR
                  SizedBox(
                    height: 40,
                    width: 300,
                    child: SearchBar(onSearchChanged: _updateSearchQuery),
                  ),
                  // const SizedBox(width: 20),
                  //TODO: SETTINGS BUTTON
                  // IconButton(
                  //   onPressed: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(builder: (context) {
                  //         return const SettingsDrawer();
                  //       }),
                  //     );
                  //   },
                  //   tooltip: 'Settings',
                  //   icon: const ImageIcon(AssetImage("icons/settings.png")),
                  // ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
              icon: const ImageIcon(AssetImage("icons/settings.png")),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      endDrawer: const AccountSettingsScreen(),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(30, 10, 30, 10),
          decoration: BoxDecoration(
            color: whitecolor.withOpacity(0.2),
            border: Border.all(color: blackcolor, width: 2),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            children: [
              //TODO: HEADER ROW
              Container(
                margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                height: 40,
                decoration: BoxDecoration(
                  color: whitecolor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      SizedBox(width: 500, child: Text("Project Name")),
                      SizedBox(
                        width: 300,
                        child: Text(
                          "Date",
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Spacer(),
                      Text("Actions"),
                    ],
                  ),
                ),
              ),

              //TODO: PROJECT LIST
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('projects')
                      .where('userUID',
                          isEqualTo: _authService.auth.currentUser
                              ?.uid) // Filter by the current user's UID
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      debugPrint('Error: ${snapshot.error}');
                      return const Center(
                          child: Text('Error connecting to Firestore.'));
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
                      projects.sort((a, b) {
                        final dateA = DateTime.parse(a['date']);
                        final dateB = DateTime.parse(b['date']);
                        return dateB.compareTo(dateA);
                      });
                      int newCount = projects.length;
                      if (_projectCount != newCount) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          setState(() {
                            _projectCount = newCount;
                          });
                        });
                      }
                      final bool pinnedMode = _projectCount >= 11;
                      final itemCount =
                          pinnedMode ? projects.length : (projects.length + 1);
                      return ListView.builder(
                        itemCount: itemCount,
                        itemBuilder: (context, index) {
                          final lastIndex = projects.length;
                          if (!pinnedMode && index == lastIndex) {
                            return Container(
                              margin: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                              alignment: Alignment.centerRight,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: lgreencolor,
                                  foregroundColor: blackcolor,
                                ),
                                onPressed: _createNewProject,
                                child: const Text('New Project'),
                              ),
                            );
                          }
                          var project = projects[index];
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: whitecolor.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 10),
                                  SizedBox(
                                      width: 500, child: Text(project['name'])),
                                  SizedBox(
                                    width: 300,
                                    child: Text(
                                      formatDateTime(project['date']),
                                      textAlign: TextAlign.left,
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
                                    icon: const ImageIcon(
                                        AssetImage("icons/draw.png")),
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
                                    icon: const ImageIcon(
                                        AssetImage("icons/export2.png")),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      final bool confirmDelete =
                                          await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Delete Project'),
                                            content: const Text(
                                                'Are you sure you want to delete this project? This action cannot be undone.'),
                                            backgroundColor: beigecolor,
                                            actions: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor: redcolor,
                                                      foregroundColor:
                                                          whitecolor,
                                                      shape:
                                                          const StadiumBorder(),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20,
                                                          vertical: 12),
                                                    ),
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(true),
                                                    // Cancel
                                                    child: const Text("Delete"),
                                                  ),
                                                  const Spacer(),
                                                  ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          lgreycolor,
                                                      foregroundColor:
                                                          blackcolor,
                                                      shape:
                                                          const StadiumBorder(),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 20,
                                                          vertical: 12),
                                                    ),
                                                    onPressed: () =>
                                                        Navigator.of(context)
                                                            .pop(false),
                                                    // Cancel
                                                    child: const Text("Cancel"),
                                                  ),
                                                ],
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
                      return const Center(
                        child: Text('No projects yet created.'),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: pinnedMode
          ? Container(
              height: 70,
              color: beigecolor,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 30),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: lgreencolor,
                  foregroundColor: blackcolor,
                ),
                onPressed: _createNewProject,
                child: const Text('New Project'),
              ),
            )
          : null,
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
        color: whitecolor,
        border: Border.all(
          color: blackcolor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextField(
        style: const TextStyle(fontSize: 14, color: blackcolor),
        textAlignVertical: TextAlignVertical.center,
        decoration: const InputDecoration(
          hintText: 'Search Projects',
          hintStyle: TextStyle(color: placeholdercolor),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
          prefixIcon: Icon(Icons.search, color: placeholdercolor),
        ),
        onChanged: onSearchChanged,
      ),
    );
  }
}

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'user_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        uid TEXT UNIQUE,
        email TEXT UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE settings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userUID TEXT,
        theme TEXT,
        toolbarPosition TEXT,
        fontSize TEXT,
        gridSize TEXT,
        layerPresets TEXT,
        gridVisibility INTEGER,
        tipsTutorials INTEGER,
        appUpdates INTEGER,
        defaultColor TEXT,
        defaultTool TEXT,
        gridSnapOnOff INTEGER,
        gridOnOff INTEGER,
        currentProject TEXT,
        snapSensitivity REAL,
        biometricEnabled INTEGER,
        unitOfMeasurement TEXT,
        snapToGridSensitivity TEXT,
        zoomSensitivity TEXT,
        autoSaveFrequency TEXT,
        FOREIGN KEY(userUID) REFERENCES users(uid)
      )
    ''');

    await db.execute('''
      CREATE TABLE projects (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userUID TEXT,
        jsonData TEXT,
        FOREIGN KEY(userUID) REFERENCES users(uid)
      )
    ''');
  }

  // CRUD operations for users
  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await database;
    return await db.insert('users', user, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getUserByUID(String uid) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'uid = ?',
      whereArgs: [uid],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    Database db = await database;
    return await db.query('users');
  }

  Future<int> updateUser(Map<String, dynamic> user) async {
    Database db = await database;
    return await db.update(
      'users',
      user,
      where: 'uid = ?',
      whereArgs: [user['uid']],
    );
  }

  Future<int> deleteUser(String uid) async {
    Database db = await database;
    return await db.delete(
      'users',
      where: 'uid = ?',
      whereArgs: [uid],
    );
  }

  // CRUD operations for settings
  Future<int> insertSettings(Map<String, dynamic> settings) async {
    Database db = await database;
    return await db.insert('settings', settings, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getSettings(String userUID) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'settings',
      where: 'userUID = ?',
      whereArgs: [userUID],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> updateSettings(Map<String, dynamic> settings) async {
    Database db = await database;
    return await db.update(
      'settings',
      settings,
      where: 'userUID = ?',
      whereArgs: [settings['userUID']],
    );
  }

  Future<int> deleteSettings(String userUID) async {
    Database db = await database;
    return await db.delete(
      'settings',
      where: 'userUID = ?',
      whereArgs: [userUID],
    );
  }

  // CRUD operations for projects
  Future<int> insertProject(Map<String, dynamic> project) async {
    Database db = await database;
    return await db.insert('projects', project, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getProjects(String userUID) async {
    Database db = await database;
    return await db.query('projects', where: 'userUID = ?', whereArgs: [userUID]);
  }

  Future<int> updateProject(Map<String, dynamic> project) async {
    Database db = await database;
    return await db.update(
      'projects',
      project,
      where: 'id = ?',
      whereArgs: [project['id']],
    );
  }

  Future<int> deleteProject(int id) async {
    Database db = await database;
    return await db.delete(
      'projects',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

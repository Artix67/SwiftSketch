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
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE
      )
    ''');

    await db.execute('''
      CREATE TABLE settings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userEmail TEXT,
        theme TEXT,
        toolbarPosition TEXT,
        fontSize TEXT,
        gridSize TEXT,
        layerPresets TEXT,
        gridVisibility INTEGER,
        tipsTutorials INTEGER,
        appUpdates INTEGER,
        gridSize REAL,
        defaultColor TEXT,
        defaultTool TEXT,
        gridSnapOnOff INTEGER,
        gridOnOff INTEGER,
        currentProject TEXT,
        snapSensitivity REAL,
        biometricEnabled INTEGER,
        FOREIGN KEY(userEmail) REFERENCES users(email)
      )
    ''');

    await db.execute('''
      CREATE TABLE projects (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userEmail TEXT,
        jsonData TEXT,
        FOREIGN KEY(userEmail) REFERENCES users(email)
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        ALTER TABLE settings ADD COLUMN theme TEXT;
      ''');
      await db.execute('''
        ALTER TABLE settings ADD COLUMN toolbarPosition TEXT;
      ''');
      await db.execute('''
        ALTER TABLE settings ADD COLUMN fontSize TEXT;
      ''');
      await db.execute('''
        ALTER TABLE settings ADD COLUMN layerPresets TEXT;
      ''');
      await db.execute('''
        ALTER TABLE settings ADD COLUMN gridVisibility INTEGER;
      ''');
      await db.execute('''
        ALTER TABLE settings ADD COLUMN tipsTutorials INTEGER;
      ''');
      await db.execute('''
        ALTER TABLE settings ADD COLUMN appUpdates INTEGER;
      ''');
    }
  }

  // CRUD operations for users
  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await database;
    return await db.insert('users', user, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
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
      where: 'email = ?',
      whereArgs: [user['email']],
    );
  }

  Future<int> deleteUser(String email) async {
    Database db = await database;
    return await db.delete(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  // CRUD operations for settings
  Future<int> insertSettings(Map<String, dynamic> settings) async {
    Database db = await database;
    return await db.insert('settings', settings, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getSettings(String userEmail) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'settings',
      where: 'userEmail = ?',
      whereArgs: [userEmail],
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> updateSettings(Map<String, dynamic> settings) async {
    Database db = await database;
    return await db.update(
      'settings',
      settings,
      where: 'userEmail = ?',
      whereArgs: [settings['userEmail']],
    );
  }

  Future<int> deleteSettings(String userEmail) async {
    Database db = await database;
    return await db.delete(
      'settings',
      where: 'userEmail = ?',
      whereArgs: [userEmail],
    );
  }

  // CRUD operations for projects
  Future<int> insertProject(Map<String, dynamic> project) async {
    Database db = await database;
    return await db.insert('projects', project, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getProjects(String userEmail) async {
    Database db = await database;
    return await db.query('projects', where: 'userEmail = ?', whereArgs: [userEmail]);
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


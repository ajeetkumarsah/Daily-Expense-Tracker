import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  static final DatabaseProvider _instance = DatabaseProvider._internal();

  factory DatabaseProvider() => _instance;

  DatabaseProvider._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'expense_tracker.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT,
            email TEXT,
            password TEXT

          )
        ''');
        db.execute('''
          CREATE TABLE expenses (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            amount REAL,
            title TEXT,
            description TEXT,
            date TEXT,
            user_id INTEGER,
            FOREIGN KEY (user_id) REFERENCES users(id)
          )
        ''');
      },
      version: 1,
    );
  }
}

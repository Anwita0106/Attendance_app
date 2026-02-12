import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('attendance.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE attendance (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT NOT NULL,
        checkInTime TEXT,
        checkOutTime TEXT,
        status TEXT NOT NULL,
        remarks TEXT
      )
    ''');
  }

  Future<int> insert(String table, Map<String, dynamic> values) async {
    final db = await database;
    return await db.insert(table, values, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> queryAll(String table) async {
    final db = await database;
    return await db.query(table, orderBy: 'date DESC');
  }

  Future<List<Map<String, dynamic>>> queryByDate(String table, String date) async {
    final db = await database;
    // Simple date string matching. For production, consider storing as INTEGER timestamps or standard ISO format without time components for querying.
    // Here assuming 'date' column stores ISO string of the date part or consistent format.
    // To match "today", we should query where date starts with YYYY-MM-DD.
    return await db.query(table, where: 'date LIKE ?', whereArgs: ['${date.substring(0, 10)}%']);
  }

  Future<int> update(String table, Map<String, dynamic> values) async {
    final db = await database;
    final id = values['id'];
    return await db.update(
      table,
      values,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

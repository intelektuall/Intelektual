import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'join_status.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE joined_status(
            title TEXT PRIMARY KEY,
            joined INTEGER
          )
        ''');
      },
    );
  }

  Future<void> saveJoinStatus(String title, bool joined) async {
    final db = await database;
    await db.insert('joined_status', {
      'title': title,
      'joined': joined ? 1 : 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, bool>> getJoinStatuses() async {
    final db = await database;
    final result = await db.query('joined_status');
    return {
      for (var row in result)
        row['title'] as String: (row['joined'] as int) == 1,
    };
  }
}

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'event_model.dart';

class DBHelper {
  static Database? _db;
  static const String _dbName = 'events.db';
  static const String _tableName = 'events';

  // getter database
  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  // inisialisasi DB
  static Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            category TEXT,
            location TEXT,
            date TEXT,
            startTime TEXT,
            endTime TEXT,
            joined INTEGER
          )
        ''');
      },
    );
  }

  // ambil semua events
  static Future<List<Event>> getEvents() async {
    final db = await database;
    final List<Map<String, dynamic>> data = await db.query(_tableName);
    return data.map((e) => Event.fromMap(e)).toList();
  }

  // insert event baru
  static Future<int> insertEvent(Event event) async {
    final db = await database;
    return await db.insert(_tableName, event.toMap());
  }

  // update event
  static Future<int> updateEvent(Event event) async {
    final db = await database;
    return await db.update(
      _tableName,
      event.toMap(),
      where: 'id = ?',
      whereArgs: [event.id],
    );
  }

  // hapus event
  static Future<int> deleteEvent(int id) async {
    final db = await database;
    return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  // hapus semua event (reset DB)
  static Future<int> clearEvents() async {
    final db = await database;
    return await db.delete(_tableName);
  }
}

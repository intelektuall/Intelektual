// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import '../Providers/event_provider.dart';

// class EventDatabase {
//   static final EventDatabase instance = EventDatabase._init();
//   static Database? _database;

//   EventDatabase._init();

//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, 'events.db');

//     _database = await openDatabase(path, version: 1, onCreate: _createDB);
//     return _database!;
//   }

//   Future _createDB(Database db, int version) async {
//     await db.execute('''
//       CREATE TABLE events(
//         id INTEGER PRIMARY KEY AUTOINCREMENT,
//         title TEXT NOT NULL,
//         category TEXT,
//         location TEXT,
//         date TEXT,
//         startTime TEXT,
//         endTime TEXT,
//         joined INTEGER
//       )
//     ''');
//   }

//   Future<void> insertEvent(Event event) async {
//     final db = await instance.database;
//     await db.insert(
//       'events',
//       event.toMap(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }

//   Future<void> updateEvent(Event event) async {
//     final db = await instance.database;
//     // gunakan title sebagai identifier sederhana (idealnya pakai id)
//     await db.update(
//       'events',
//       event.toMap(),
//       where: 'title = ?',
//       whereArgs: [event.title],
//     );
//   }

//   Future<List<Event>> getEvents() async {
//     final db = await instance.database;
//     final result = await db.query('events');
//     return result.map((json) => Event.fromMap(json)).toList();
//   }

//   Future<void> deleteAll() async {
//     final db = await instance.database;
//     await db.delete('events');
//   }
// }

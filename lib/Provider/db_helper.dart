import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'animal_submissions.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE submissions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        type TEXT NOT NULL,
        location TEXT NOT NULL,
        count TEXT NOT NULL,
        desc TEXT NOT NULL,
        imagePath TEXT,
        timestamp TEXT NOT NULL,
        status TEXT NOT NULL,
        isSynced INTEGER DEFAULT 0
      )
    ''');
  }

  // CREATE - Insert new submission
  Future<int> insertSubmission(Map<String, dynamic> submission) async {
    final db = await database;
    return await db.insert('submissions', submission);
  }

  // READ - Get all submissions
  Future<List<Map<String, dynamic>>> getSubmissions() async {
    final db = await database;
    return await db.query('submissions', orderBy: 'timestamp DESC');
  }

  // READ - Get submissions by sync status
  Future<List<Map<String, dynamic>>> getUnsyncedSubmissions() async {
    final db = await database;
    return await db.query(
      'submissions',
      where: 'isSynced = ?',
      whereArgs: [0],
      orderBy: 'timestamp DESC',
    );
  }

  // READ - Get submission by ID
  Future<Map<String, dynamic>?> getSubmissionById(int id) async {
    final db = await database;
    final results = await db.query(
      'submissions',
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  // UPDATE - Update sync status
  Future<int> updateSyncStatus(int id, bool isSynced) async {
    final db = await database;
    return await db.update(
      'submissions',
      {'isSynced': isSynced ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // UPDATE - Update submission status
  Future<int> updateSubmissionStatus(int id, String status) async {
    final db = await database;
    return await db.update(
      'submissions',
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // UPDATE - Update entire submission
  Future<int> updateSubmission(int id, Map<String, dynamic> submission) async {
    final db = await database;
    return await db.update(
      'submissions',
      submission,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE - Delete submission
  Future<int> deleteSubmission(int id) async {
    final db = await database;
    return await db.delete(
      'submissions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // DELETE - Delete all submissions
  Future<int> deleteAllSubmissions() async {
    final db = await database;
    return await db.delete('submissions');
  }

  // COUNT - Get total submissions count
  Future<int> getSubmissionsCount() async {
    final db = await database;
    final results = await db.rawQuery('SELECT COUNT(*) FROM submissions');
    return results.first.values.first as int;
  }
}
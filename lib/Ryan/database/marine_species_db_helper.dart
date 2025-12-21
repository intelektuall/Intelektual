import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/marine_species.dart';

class MarineSpeciesDBHelper {
  static final MarineSpeciesDBHelper instance = MarineSpeciesDBHelper._init();
  static Database? _database;

  MarineSpeciesDBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('marine_species_actions.db');
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

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE actions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        imagePath TEXT,
        description TEXT,
        category TEXT,
        ocean TEXT,
        subtype TEXT,
        action TEXT
      )
    ''');
  }

  Future<void> insertAction(MarineSpecies species, String action) async {
    final db = await instance.database;
    await db.insert(
      'actions',
      {
        'name': species.name,
        'imagePath': species.imagePath,
        'description': species.description,
        'category': species.category,
        'ocean': species.ocean,
        'subtype': species.subtype,
        'action': action,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getActions(String action) async {
    final db = await instance.database;
    return await db.query('actions', where: 'action = ?', whereArgs: [action]);
  }

  Future<void> deleteAction(String name, String action) async {
    final db = await instance.database;
    await db.delete(
      'actions',
      where: 'name = ? AND action = ?',
      whereArgs: [name, action],
    );
  }

  Future<void> clearAll() async {
    final db = await instance.database;
    await db.delete('actions');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

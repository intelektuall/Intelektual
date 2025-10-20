import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../Notification/notification_model.dart';

class NotificationDatabase {
  static final NotificationDatabase instance = NotificationDatabase._init();
  static Database? _database;

  NotificationDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notifications.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notifications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT,
        lokasi TEXT,
        timestamp TEXT,
        tipe TEXT
      )
    ''');
  }

  Future<void> insertNotification(NotificationModel notif) async {
    final db = await instance.database;
    await db.insert('notifications', notif.toMap());
  }

  Future<List<NotificationModel>> getAllNotifications() async {
    final db = await instance.database;
    final result = await db.query('notifications', orderBy: 'id DESC');
    return result.map((json) => NotificationModel.fromMap(json)).toList();
  }

  Future<void> deleteAll() async {
    final db = await instance.database;
    await db.delete('notifications');
  }

  Future<void> deleteById(int id) async {
    final db = await instance.database;
    await db.delete('notifications', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteDatabaseFile() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'notifications.db');
    await deleteDatabase(path);
    print("🗑️ Database lama dihapus");
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

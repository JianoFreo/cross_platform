import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  static Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'tasks.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks(
            id TEXT PRIMARY KEY,
            title TEXT,
            isDone INTEGER,
            createdAt TEXT,
            dueDate TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insertTask(Task task) async {
    final database = await db;
    await database.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Task>> getTasks() async {
    final database = await db;
    final maps = await database.query('tasks', orderBy: 'createdAt DESC');
    return maps.map((map) => Task.fromMap(map)).toList();
  }

  static Future<void> updateTask(Task task) async {
    final database = await db;
    await database.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  static Future<void> deleteTask(String id) async {
    final database = await db;
    await database.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
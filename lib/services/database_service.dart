import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    return await initDatabase();
  }

  Future<Database> initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'faces.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(
        "CREATE TABLE faces (id INTEGER PRIMARY KEY, name TEXT, embedding TEXT)",
      );
    });
  }

  Future<void> saveFace(String name, List<double> embedding) async {
    final db = await database;
    await db.insert("faces", {"name": name, "embedding": embedding.join(",")});
  }

  Future<List<Map<String, dynamic>>> getStoredFaces() async {
    final db = await database;
    return await db.query("faces");
  }
}

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseHelper {
  DatabaseHelper() {
    _createDatabase();
  }
  static const String tableName = "student";
  late Database _db;

  Future<Database> _createDatabase() async {
    final dataPath = await getDatabasesPath();

    String path = join(dataPath, "student.db");

    _db = await openDatabase(path);

    await _db.execute(
      "CREATE TABLE IF NOT EXISTS student (id INTEGER PRIMARY KEY,name TEXT,address TEXT,phone TEXT,email TEXT)",
    );

    return _db;
  }

  Future<int> insertStudent(Map<String, dynamic> student) async {
    _db = await _createDatabase();

    return await _db.insert(tableName, student);
  }

  Future<List<Map<String, dynamic>>> getAllStudent() async {
    _db = await _createDatabase();
    return await _db.query(
      tableName,
      columns: ['id', 'name', 'address', 'phone', 'email'],
    );
  }

  Future<void> deleteStudent(int id) async {
    _db = await _createDatabase();

    await _db.delete(tableName, where: "id=?", whereArgs: [id]);
  }

  Future<void> updateStudent(Map<String, dynamic> student, int id) async {
    _db = await _createDatabase();

    await _db.update(tableName, student, where: 'id=?', whereArgs: [id]);
  }
}

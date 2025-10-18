import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/employee.dart';

class DBHelper {
  static Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'payroll.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE employees (
            id INTEGER PRIMARY KEY,
            name TEXT,
            position TEXT,
            baseSalary REAL,
            allowance REAL,
            deduction REAL
          )
        ''');
      },
    );
  }

  Future<int> insertEmployee(Employee emp) async {
    final db = await database;
    return await db.insert(
      'employees',
      emp.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Employee>> getEmployees() async {
    final db = await database;
    final result = await db.query('employees');
    return result.map((e) => Employee.fromMap(e)).toList();
  }

  Future<int> updateEmployee(Employee emp) async {
    final db = await database;
    return await db.update(
      'employees',
      emp.toMap(),
      where: 'id = ?',
      whereArgs: [emp.id],
    );
  }

  Future<int> deleteEmployee(int id) async {
    final db = await database;
    return await db.delete('employees', where: 'id = ?', whereArgs: [id]);
  }
}

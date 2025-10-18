import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/employee.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  DBHelper._internal();

  static Database? _db;

  Future<Database> get db async {
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
          CREATE TABLE employees(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            position TEXT,
            baseSalary REAL,
            allowance REAL,
            deduction REAL,
            totalSalary REAL
          )
        ''');
      },
    );
  }

  Future<int> insertEmployee(Employee emp) async {
    final database = await db;
    emp.totalSalary = emp.baseSalary + emp.allowance - emp.deduction;
    return await database.insert('employees', emp.toMap());
  }

  Future<List<Employee>> getEmployees() async {
    final database = await db;
    final result = await database.query('employees', orderBy: 'id DESC');
    return result.map((e) => Employee.fromMap(e)).toList();
  }

  Future<int> updateEmployee(Employee emp) async {
    final database = await db;
    emp.totalSalary = emp.baseSalary + emp.allowance - emp.deduction;
    return await database.update(
      'employees',
      emp.toMap(),
      where: 'id = ?',
      whereArgs: [emp.id],
    );
  }

  Future<int> deleteEmployee(int id) async {
    final database = await db;
    return await database.delete('employees', where: 'id = ?', whereArgs: [id]);
  }
}

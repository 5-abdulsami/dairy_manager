// lib/core/database/database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'dairy_shop.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create suppliers table
    await db.execute('''
      CREATE TABLE suppliers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phoneNumber TEXT,
        productType TEXT NOT NULL,
        rate REAL NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');

    // Create purchases table
    await db.execute('''
      CREATE TABLE purchases(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        supplierId INTEGER NOT NULL,
        supplierName TEXT NOT NULL,
        quantity REAL NOT NULL,
        rate REAL NOT NULL,
        totalAmount REAL NOT NULL,
        date TEXT NOT NULL,
        productType TEXT NOT NULL,
        unit TEXT NOT NULL,
        FOREIGN KEY (supplierId) REFERENCES suppliers (id)
      )
    ''');

    // Create sales table
    await db.execute('''
      CREATE TABLE sales(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productType TEXT NOT NULL,
        quantity REAL NOT NULL,
        rate REAL NOT NULL,
        totalAmount REAL NOT NULL,
        date TEXT NOT NULL,
        unit TEXT NOT NULL
      )
    ''');
  }
}

import 'package:flutter_general_reviewer/models/app_category.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService extends GetxService {
  static Database? _db;

  Future<Database> init() async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  // DATABASE Creation
  Future<Database> getDatabase() async {
    final databaseDirectory = await getDatabasesPath();
    final path = join(databaseDirectory, "general_reviewer_db.db");
    final database = await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },

      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE Categories (
          CategoryId INTEGER PRIMARY KEY AUTOINCREMENT,
          CategoryName TEXT NOT NULL,
          CategoryColor TEXT NOT NULL
        )
        ''');
        await db.execute('''
        CREATE TABLE Medias (
          MediaId INTEGER PRIMARY KEY AUTOINCREMENT,
          CategoryId INTEGER NOT NULL,
          MediaName TEXT NOT NULL,
          MediaRating INTEGER NOT NULL,
          MediaDescription TEXT,
          ImagePath TEXT,
          Status TEXT,

          FOREIGN KEY(CategoryId) REFERENCES Categories (CategoryId) ON DELETE CASCADE
        ) 
        ''');
        await db.execute('''
        CREATE TABLE Review (
          ReviewId INTEGER PRIMARY KEY AUTOINCREMENT,
          MediaId INTEGER NOT NULL,
          UserReview TEXT NOT NULL,
          ReviewDate TEXT NOT NULL,

          FOREIGN KEY(MediaId) REFERENCES Medias (MediaId) ON DELETE CASCADE
        )
        ''');
      },
    );
    return database;
  }

  // CRUD Operations
  Future<List<AppCategory>?> getCategories() async {
    final db = await init();
    final data = await db.query("Categories");
    List<AppCategory> categories = data
        .map((e) => AppCategory.fromMap(e))
        .toList();
    return categories;
  }
}

import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class DBConstants {
  // For Categories
  static const categoryTable = "Categories";
  static const categoryId = "CategoryId";
  static const categoryName = "CategoryName";
  static const categoryColor = "CategoryColor";

  // For Status
  static const statusTable = "Statuses";
  static const statusId = "StatusId";
  static const statusName = "StatusName";
  static const statusColor = "StatusColor";

  // For Medias
  static const mediaTable = "Medias";
  static const mediaId = "MediaId";
  static const mediaCategoryId = "CategoryId";
  static const mediaStatusId = "StatusId";
  static const mediaName = "MediaName";
  static const mediaRating = "MediaRating";
  static const mediaDescription = "MediaDescription";
  static const mediaImage = "ImagePath";

  // For Reviews
  static const reviewTable = "Reviews";
  static const reviewId = "ReviewId";
  static const reviewMediaId = "MediaId";
  static const reviewContent = "Content";
  static const reviewDate = "Date";
}

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
        // Categories Table Creation
        await db.execute('''
          CREATE TABLE ${DBConstants.categoryTable} (
            ${DBConstants.categoryId} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${DBConstants.categoryName} TEXT NOT NULL,
            ${DBConstants.categoryColor} TEXT NOT NULL
          )
        ''');

        // Status Table Creation
        await db.execute('''
          CREATE TABLE ${DBConstants.statusTable} (
            ${DBConstants.statusId} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${DBConstants.statusName} TEXT NOT NULL UNIQUE,
            ${DBConstants.statusColor} TEXT NOT NULL
          );
        ''');

        // Some Pre Defined Values For Status Table
        await db.execute('''
          INSERT INTO ${DBConstants.statusTable} (${DBConstants.statusName}, ${DBConstants.statusColor})
          VALUES 
            ('Completed', '#4CAF50'),
            ('In Progress', '#FF9800'),
            ('Plan to Watch', '#2196F3'),
            ('Dropped', '#F44336')
        ''');

        // Media Table Creation
        await db.execute('''
          CREATE TABLE ${DBConstants.mediaTable} (
            ${DBConstants.mediaId} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${DBConstants.mediaCategoryId} INTEGER NOT NULL,
            ${DBConstants.mediaStatusId} INTEGER ,

            ${DBConstants.mediaName} TEXT NOT NULL,
            ${DBConstants.mediaRating} INTEGER NOT NULL,
            ${DBConstants.mediaDescription} TEXT,
            ${DBConstants.mediaImage} TEXT,
            

            FOREIGN KEY(${DBConstants.mediaCategoryId}) REFERENCES ${DBConstants.categoryTable} (${DBConstants.categoryId}) ON DELETE CASCADE,
            FOREIGN KEY(${DBConstants.mediaStatusId}) REFERENCES ${DBConstants.statusTable} (${DBConstants.statusId}) ON DELETE SET NULL 
          ) 
        ''');

        // Review Table Creation
        await db.execute('''
          CREATE TABLE ${DBConstants.reviewTable} (
            ${DBConstants.reviewId} INTEGER PRIMARY KEY AUTOINCREMENT,
            ${DBConstants.reviewMediaId} INTEGER NOT NULL,
            ${DBConstants.reviewContent} TEXT NOT NULL,
            ${DBConstants.reviewDate} TEXT NOT NULL,

            FOREIGN KEY(${DBConstants.reviewMediaId}) REFERENCES ${DBConstants.mediaTable} (${DBConstants.mediaId}) ON DELETE CASCADE
          )
        ''');
      },
    );
    return database;
  }
}

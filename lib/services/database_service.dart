import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class DBConstants {
  // For Categories
  static const categoryTable = "Categories";
  static const categoryId = "CategoryId";
  static const categoryParentId = 'CategoryParentId';
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

  Database get db => _db!;

  Future<DatabaseService> init() async {
    if (_db != null) return this;
    _db = await getDatabase();
    return this;
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
            ${DBConstants.categoryParentId} INTEGER,
            ${DBConstants.categoryName} TEXT NOT NULL,
            ${DBConstants.categoryColor} TEXT NOT NULL,

            FOREIGN KEY(${DBConstants.categoryParentId}) REFERENCES ${DBConstants.categoryTable} (${DBConstants.categoryId}) ON DELETE CASCADE
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

  // Database Import/Export Functions Helpers
  Future<String> _getDbPath() async {
    final databaseDirectory = await getDatabasesPath();
    return join(databaseDirectory, "general_reviewer_db.db");
  }

  // // Permission Handling
  // Future<bool> _checkAndRequestPermission() async {
  //   if (Platform.isAndroid) {
  //     final status = await Permission.storage.request();
  //     if (status.isGranted) return true;

  //     // Fallback for Android 13+ (API level 33+)
  //     final photosStatus = await Permission.photos.request();
  //     if (status.isGranted) return true;

  //     if (status.isPermanentlyDenied || photosStatus.isPermanentlyDenied) {
  //       await openAppSettings();
  //     }
  //     return false;
  //   }
  //   return true;
  // }

  // Close DB connection safely before overwriting the file
  Future<void> _closeDatabase() async {
    if (_db != null && _db!.isOpen) {
      await _db!.close();
      _db = null;
    }
  }

  // EXPORT DATABASE
  Future<bool> exportDatabase() async {
    try {
      final dbPath = await _getDbPath();
      final dbFile = File(dbPath);
      if (!await dbFile.exists()) return false;

      final Uint8List bytes = await dbFile.readAsBytes();

      final now = DateTime.now();
      final month = now.month.toString().padLeft(2, '0');
      final day = now.day.toString().padLeft(2, '0');
      final hour = now.hour.toString().padLeft(2, '0');
      final minute = now.minute.toString().padLeft(2, '0');
      final timeStamp = '${now.year}$month${day}_$hour$minute';

      // Opens the system "Save as" dialog; the picker writes the file itself.
      final savedPath = await FilePicker.saveFile(
        fileName: 'general_reviewer_backup_$timeStamp.db',
        bytes: bytes,
      );

      return savedPath != null;
    } catch (e) {
      return false;
    }
  }

  // IMPORT DATABASE
  Future<bool> importDatabase() async {
    try {
      final result = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['db', 'sqlite'],
      );

      if (result == null || result.path == null) {
        return false;
      }

      final backupFile = File(result.path!);

      final header = await backupFile.openRead(0, 16).first;
      if (String.fromCharCodes(header) != 'SQLite format 3\u0000') {
        return false;
      }

      final dbPath = await _getDbPath();

      await _closeDatabase();
      await backupFile.copy(dbPath);
      _db = await getDatabase();

      return true;
    } catch (e) {
      _db ??= await getDatabase();
      return false;
    }
  }
}

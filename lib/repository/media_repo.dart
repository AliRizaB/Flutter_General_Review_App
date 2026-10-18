import 'package:flutter_general_reviewer/models/app_media.dart';
import 'package:flutter_general_reviewer/services/database_service.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class MediaRepository extends GetxController {
  Database get db => Get.find<DatabaseService>().db;

  // CRUD Operations
  // Create Operation For Table
  Future<void> addMedia(AppMedia media) async {
    await db.insert(DBConstants.mediaTable, media.toMap());
  }

  // Read Operation For Medias For specific Category
  Future<List<AppMedia>> getMedias(int categoryId) async {
    final data = await db.query(
      DBConstants.mediaTable,
      where: '${DBConstants.mediaCategoryId} = ?',
      whereArgs: [categoryId],
    );
    List<AppMedia> medias = data.map((e) => AppMedia.fromMap(e)).toList();
    return medias;
  }

  // Update Operation for Media
  Future<void> updateMedia(AppMedia media) async {
    await db.update(
      DBConstants.mediaTable,
      media.toMap(),
      where: '${DBConstants.mediaId} = ?',
      whereArgs: [media.id],
    );
  }

  // Delete operation for media
  Future<void> deleteMedia(int id) async {
    await db.delete(
      DBConstants.mediaTable,
      where: '${DBConstants.mediaId} = ?',
      whereArgs: [id],
    );
  }
}

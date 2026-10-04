import 'package:flutter/foundation.dart';
import 'package:flutter_general_reviewer/models/app_media.dart';
import 'package:flutter_general_reviewer/services/database_service.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class MediaRepository extends GetxController {
  late final Database db;

  @override
  void onInit() {
    super.onInit();
    db = Get.find<DatabaseService>().db;
  }

  // CRUD Operations
  // Create Operation For Table
  Future<void> addMedia(AppMedia media) async {
    try {
      await db.insert(DBConstants.mediaTable, media.toMap());
    } catch (e) {
      debugPrint("Error while Creating Media: \nERROR: ${e.toString()}");
    }
  }

  // Read Operation For Medias For specific Category
  Future<List<AppMedia>> getMedias(int categoryId) async {
    try {
      final data = await db.query(
        DBConstants.mediaTable,
        where: '${DBConstants.mediaCategoryId} = ?',
        whereArgs: [categoryId],
      );
      List<AppMedia> medias = data.map((e) => AppMedia.fromMap(e)).toList();
      return medias;
    } catch (e) {
      debugPrint("Error while Getting Medias: \nERROR: ${e.toString()}");
      return List.empty();
    }
  }

  // Update Operation for Media
  Future<void> updateMedia(AppMedia media) async {
    try {
      await db.update(
        DBConstants.mediaTable,
        media.toMap(),
        where: '${DBConstants.mediaId} = ?',
        whereArgs: [media.id],
      );
    } catch (e) {
      debugPrint("Error while Updating Media: \nERROR: ${e.toString()}");
    }
  }

  // Delete operation for media
  Future<void> deleteMedia(int id) async {
    try {
      await db.delete(
        DBConstants.mediaTable,
        where: '${DBConstants.mediaId} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      debugPrint("Error while Deleting Media: \nERROR: ${e.toString()}");
    }
  }
}

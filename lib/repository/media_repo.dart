import 'package:flutter_general_reviewer/base/base_controller.dart';
import 'package:flutter_general_reviewer/models/app_media.dart';
import 'package:flutter_general_reviewer/services/database_service.dart';
import 'package:get/instance_manager.dart';
import 'package:sqflite/sqflite.dart';

class MediaRepository extends BaseController {
  late final DatabaseService databaseService;
  late final Database db;

  Future<void> init() async {
    databaseService = Get.find<DatabaseService>();
    db = await databaseService.init();
  }

  @override
  void onInit() {
    super.onInit();
    init();
  }

  // CRUD Operations
  // Create Operation For Table
  Future<void> addMedia(AppMedia media) async {
    try {
      setLoading(true);

      await db.insert(DBConstants.mediaTable, media.toMap());

      showSuccessSnackBar(message: "Succesfully Created The Media ");
    } catch (e) {
      showErrorSnackBar(
        message: "Error: While creating the Media \nERROR:${e.toString()} ",
      );
    } finally {
      setLoading(false);
    }
  }

  // Read Operation For Medias For specific Category
  Future<List<AppMedia>?> getMedias(int categoryId) async {
    try {
      setLoading(true);

      final data = await db.query(
        DBConstants.mediaTable,
        where: '${DBConstants.mediaCategoryId} = ?',
        whereArgs: [categoryId],
      );
      List<AppMedia> media = data.map((e) => AppMedia.fromMap(e)).toList();
      showSuccessSnackBar(message: "Succesfully Getting Media");
      return media;
    } catch (e) {
      showErrorSnackBar(
        message: "Error: While Getting Media \nERROR:${e.toString()}",
      );
      return null;
    } finally {
      setLoading(false);
    }
  }

  // Update Operation for Media
  Future<void> updateMedia(AppMedia media) async {
    try {
      setLoading(true);

      await db.update(
        DBConstants.mediaTable,
        media.toMap(),
        where: '${DBConstants.mediaId} = ?',
        whereArgs: [media.id],
      );
      showSuccessSnackBar(message: "Succesfully Updated The Media");
    } on Exception catch (e) {
      showErrorSnackBar(
        message: "Error: While Updating The Media\nERROR:${e.toString()}",
      );
    } finally {
      setLoading(false);
    }
  }

  // Delete operation for media
  Future<void> deleteMedia(int id) async {
    try {
      setLoading(true);

      await db.delete(
        DBConstants.mediaTable,
        where: '${DBConstants.mediaId} = ?',
        whereArgs: [id],
      );
      showSuccessSnackBar(message: "Succesfully Deleted The Media");
    } on Exception catch (e) {
      showErrorSnackBar(
        message: "Error: While Deleting The Media\nERROR:${e.toString()}",
      );
    } finally {
      setLoading(false);
    }
  }
}

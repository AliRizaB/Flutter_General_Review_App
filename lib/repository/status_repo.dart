import 'package:flutter_general_reviewer/base/base_controller.dart';
import 'package:flutter_general_reviewer/models/app_status.dart';
import 'package:flutter_general_reviewer/services/database_service.dart';
import 'package:get/instance_manager.dart';
import 'package:sqflite/sqflite.dart';

class StatusRepository extends BaseController {
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
  Future<void> addStatus(AppStatus status) async {
    try {
      setLoading(true);

      await db.insert(DBConstants.statusTable, status.toMap());

      showSuccessSnackBar(message: "Succesfully Created The Status ");
    } catch (e) {
      showErrorSnackBar(
        message: "Error: While creating the Status \nERROR:${e.toString()} ",
      );
    } finally {
      setLoading(false);
    }
  }

  // Read Operation For Statuses
  Future<List<AppStatus>?> getStatuses() async {
    try {
      setLoading(true);
      final data = await db.query(DBConstants.statusTable);
      List<AppStatus> categories = data
          .map((e) => AppStatus.fromMap(e))
          .toList();
      showSuccessSnackBar(message: "Succesfully Getting Statuses");
      return categories;
    } catch (e) {
      showErrorSnackBar(
        message: "Error: While Getting Statuses \nERROR:${e.toString()}",
      );
      return null;
    } finally {
      setLoading(false);
    }
  }

  // Update Operation for Status
  Future<void> updateStatus(AppStatus status) async {
    try {
      setLoading(true);

      await db.update(
        DBConstants.statusTable,
        status.toMap(),
        where: '${DBConstants.statusId} = ?',
        whereArgs: [status.id],
      );
      showSuccessSnackBar(message: "Succesfully Updated The Status");
    } on Exception catch (e) {
      showErrorSnackBar(
        message: "Error: While Updating The Status \nERROR:${e.toString()}",
      );
    } finally {
      setLoading(false);
    }
  }

  // Delete operation for status
  Future<void> deleteStatus(int id) async {
    try {
      setLoading(true);

      await db.delete(
        DBConstants.statusTable,
        where: '${DBConstants.statusId} = ?',
        whereArgs: [id],
      );
      showSuccessSnackBar(message: "Succesfully Deleted The Status");
    } on Exception catch (e) {
      showErrorSnackBar(
        message: "Error: While Deleting The Status \nERROR:${e.toString()}",
      );
    } finally {
      setLoading(false);
    }
  }
}

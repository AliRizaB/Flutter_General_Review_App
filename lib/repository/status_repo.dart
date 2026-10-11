import 'package:flutter/foundation.dart';
import 'package:flutter_general_reviewer/models/media_status.dart';
import 'package:flutter_general_reviewer/services/database_service.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:sqflite/sqflite.dart';

class StatusRepository extends GetxController {
  late final Database db;

  @override
  void onInit() {
    super.onInit();
    db = Get.find<DatabaseService>().db;
  }

  // CRUD Operations
  // Create Operation For Table
  Future<void> addStatus(MediaStatus status) async {
    try {
      await db.insert(DBConstants.statusTable, status.toMap());
    } catch (e) {
      debugPrint("Error while creating Status: \nERROR: ${e.toString()}");
    }
  }

  Future<MediaStatus> getStatus(int id) async {
    try {
      final data = await db.query(
        DBConstants.statusTable,
        where: '${DBConstants.statusId} = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (data.isNotEmpty) {
        return MediaStatus.fromMap(data.first);
      } else {
        throw Exception("Status with ID $id not found");
      }
    } catch (e) {
      debugPrint("Error while Getting Status: \nERROR: ${e.toString()}");
      rethrow;
    }
  }

  // Read Operation For Statuses
  Future<List<MediaStatus>> getStatuses() async {
    try {
      final data = await db.query(DBConstants.statusTable);
      List<MediaStatus> statuses = data
          .map((e) => MediaStatus.fromMap(e))
          .toList();
      return statuses;
    } catch (e) {
      debugPrint("Error while Getting Status: \nERROR: ${e.toString()}");
      return List.empty();
    }
  }

  // Update Operation for Status
  Future<void> updateStatus(MediaStatus status) async {
    try {
      await db.update(
        DBConstants.statusTable,
        status.toMap(),
        where: '${DBConstants.statusId} = ?',
        whereArgs: [status.id],
      );
    } catch (e) {
      debugPrint("Error while Updating Status: \nERROR: ${e.toString()}");
    }
  }

  // Delete operation for status
  Future<void> deleteStatus(int id) async {
    try {
      await db.delete(
        DBConstants.statusTable,
        where: '${DBConstants.statusId} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      debugPrint("Error while Deleting Status: \nERROR: ${e.toString()}");
    }
  }
}

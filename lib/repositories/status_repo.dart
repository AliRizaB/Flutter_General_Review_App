import 'package:flutter_general_reviewer/models/media_status.dart';
import 'package:flutter_general_reviewer/services/database_service.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:sqflite/sqflite.dart';

class StatusRepository extends GetxController {
  Database get db => Get.find<DatabaseService>().db;

  // CRUD Operations
  // Create Operation For Table
  Future<void> addStatus(MediaStatus status) async {
    await db.insert(DBConstants.statusTable, status.toMap());
  }

  Future<MediaStatus> getStatus(int id) async {
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
  }

  // Read Operation For Statuses
  Future<List<MediaStatus>> getStatuses() async {
    final data = await db.query(DBConstants.statusTable);
    List<MediaStatus> statuses = data
        .map((e) => MediaStatus.fromMap(e))
        .toList();
    return statuses;
  }

  // Update Operation for Status
  Future<void> updateStatus(MediaStatus status) async {
    await db.update(
      DBConstants.statusTable,
      status.toMap(),
      where: '${DBConstants.statusId} = ?',
      whereArgs: [status.id],
    );
  }

  // Delete operation for status
  Future<void> deleteStatus(int id) async {
    await db.delete(
      DBConstants.statusTable,
      where: '${DBConstants.statusId} = ?',
      whereArgs: [id],
    );
  }
}

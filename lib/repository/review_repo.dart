import 'package:flutter/foundation.dart';
import 'package:flutter_general_reviewer/models/app_review.dart';
import 'package:flutter_general_reviewer/services/database_service.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class ReviewRepository extends GetxController {
  late final Database db;

  @override
  void onInit() {
    super.onInit();
    db = Get.find<DatabaseService>().db;
  }

  // CRUD Operations
  // Create Operation For Table
  Future<void> addCReview(AppReview review) async {
    try {
      await db.insert(DBConstants.reviewTable, review.toMap());
    } catch (e) {
      debugPrint("Error while creating Review: \nERROR: ${e.toString()}");
    }
  }

  // Read Operation For Reviews
  Future<List<AppReview>> getReviews(int mediaId) async {
    try {
      final data = await db.query(
        DBConstants.reviewTable,
        where: '${DBConstants.reviewMediaId} = ?',
        whereArgs: [mediaId],
      );
      List<AppReview> reviews = data.map((e) => AppReview.fromMap(e)).toList();
      return reviews;
    } catch (e) {
      debugPrint("Error while getting Review: \nERROR: ${e.toString()}");

      return List.empty();
    }
  }

  // Update Operation for Review
  Future<void> updateReview(AppReview review) async {
    try {
      await db.update(
        DBConstants.reviewTable,
        review.toMap(),
        where: '${DBConstants.reviewId} = ?',
        whereArgs: [review.id],
      );
    } catch (e) {
      debugPrint("Error while Updating Review: \nERROR: ${e.toString()}");
    }
  }

  // Delete operation for review
  Future<void> deleteReview(int id) async {
    try {
      await db.delete(
        DBConstants.reviewTable,
        where: '${DBConstants.reviewId} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      debugPrint("Error while Deleting Review: \nERROR: ${e.toString()}");
    }
  }
}

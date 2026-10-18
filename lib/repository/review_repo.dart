import 'package:flutter_general_reviewer/models/media_review.dart';
import 'package:flutter_general_reviewer/services/database_service.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class ReviewRepository extends GetxController {
  Database get db => Get.find<DatabaseService>().db;

  // CRUD Operations
  // Create Operation For Table
  Future<void> addReview(MediaReview review) async {
    await db.insert(DBConstants.reviewTable, review.toMap());
  }

  // Read Operation For Reviews
  Future<List<MediaReview>> getReviews(int mediaId) async {
    final data = await db.query(
      DBConstants.reviewTable,
      where: '${DBConstants.reviewMediaId} = ?',
      whereArgs: [mediaId],
    );
    List<MediaReview> reviews = data
        .map((e) => MediaReview.fromMap(e))
        .toList();
    return reviews;
  }

  // Update Operation for Review
  Future<void> updateReview(MediaReview review) async {
    await db.update(
      DBConstants.reviewTable,
      review.toMap(),
      where: '${DBConstants.reviewId} = ?',
      whereArgs: [review.id],
    );
  }

  // Delete operation for review
  Future<void> deleteReview(int id) async {
    await db.delete(
      DBConstants.reviewTable,
      where: '${DBConstants.reviewId} = ?',
      whereArgs: [id],
    );
  }
}

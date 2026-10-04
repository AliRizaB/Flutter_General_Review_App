import 'package:flutter_general_reviewer/base/base_controller.dart';
import 'package:flutter_general_reviewer/models/app_review.dart';
import 'package:flutter_general_reviewer/services/database_service.dart';
import 'package:get/instance_manager.dart';
import 'package:sqflite/sqflite.dart';

class ReviewRepository extends BaseController {
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
  Future<void> addCReview(AppReview review) async {
    try {
      setLoading(true);

      await db.insert(DBConstants.reviewTable, review.toMap());

      showSuccessSnackBar(message: "Succesfully Created The Review ");
    } catch (e) {
      showErrorSnackBar(
        message: "Error: While creating the Review\nERROR:${e.toString()} ",
      );
    } finally {
      setLoading(false);
    }
  }

  // Read Operation For Reviews
  Future<List<AppReview>?> getReviews(int mediaId) async {
    try {
      setLoading(true);
      final data = await db.query(
        DBConstants.reviewTable,
        where: '${DBConstants.reviewMediaId} = ?',
        whereArgs: [mediaId],
      );
      List<AppReview> reviews = data.map((e) => AppReview.fromMap(e)).toList();
      showSuccessSnackBar(message: "Succesfully Got Reviews");
      return reviews;
    } catch (e) {
      showErrorSnackBar(
        message: "Error: While Getting Reviews\nERROR:${e.toString()}",
      );
      return null;
    } finally {
      setLoading(false);
    }
  }

  // Update Operation for Review
  Future<void> updateReview(AppReview review) async {
    try {
      setLoading(true);

      await db.update(
        DBConstants.reviewTable,
        review.toMap(),
        where: '${DBConstants.reviewId} = ?',
        whereArgs: [review.id],
      );
      showSuccessSnackBar(message: "Succesfully Updated The Review");
    } on Exception catch (e) {
      showErrorSnackBar(
        message: "Error: While Updating The Review\nERROR:${e.toString()}",
      );
    } finally {
      setLoading(false);
    }
  }

  // Delete operation for review
  Future<void> deleteReview(int id) async {
    try {
      setLoading(true);

      await db.delete(
        DBConstants.reviewTable,
        where: '${DBConstants.reviewId} = ?',
        whereArgs: [id],
      );
      showSuccessSnackBar(message: "Succesfully Deleted The Review");
    } on Exception catch (e) {
      showErrorSnackBar(
        message: "Error: While Deleting The Review\nERROR:${e.toString()}",
      );
    } finally {
      setLoading(false);
    }
  }
}

import 'package:flutter_general_reviewer/base/base_controller.dart';
import 'package:flutter_general_reviewer/models/app_category.dart';
import 'package:flutter_general_reviewer/services/database_service.dart';
import 'package:get/instance_manager.dart';
import 'package:sqflite/sqflite.dart';

class CategoryCrudController extends BaseController {
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
  Future<void> addCategory(AppCategory category) async {
    try {
      setLoading(true);

      await db.insert(DBConstants.categoryTable, category.toMap());

      showSuccessSnackBar(message: "Succesfully Created The Category ");
    } catch (e) {
      showErrorSnackBar(
        message: "Error: While creating the Category \nERROR:${e.toString()} ",
      );
    } finally {
      setLoading(false);
    }
  }

  // Read Operation For Categories
  Future<List<AppCategory>?> getCategories() async {
    try {
      setLoading(true);
      final data = await db.query(DBConstants.categoryTable);
      List<AppCategory> categories = data
          .map((e) => AppCategory.fromMap(e))
          .toList();
      showSuccessSnackBar(message: "Succesfully Getting Categories");
      return categories;
    } catch (e) {
      showErrorSnackBar(
        message: "Error: While Getting Categories \nERROR:${e.toString()}",
      );
      return null;
    } finally {
      setLoading(false);
    }
  }

  // Update Operation for Category
  Future<void> updateCategory(AppCategory category) async {
    try {
      setLoading(true);

      await db.update(
        DBConstants.categoryTable,
        category.toMap(),
        where: '${DBConstants.categoryId} = ?',
        whereArgs: [category.id],
      );
      showSuccessSnackBar(message: "Succesfully Updated The Category");
    } on Exception catch (e) {
      showErrorSnackBar(
        message: "Error: While Updating The Category \nERROR:${e.toString()}",
      );
    } finally {
      setLoading(false);
    }
  }

  // Delete operation for category
  Future<void> deleteCategory(int id) async {
    try {
      setLoading(true);

      await db.delete(
        DBConstants.categoryTable,
        where: '${DBConstants.categoryId} = ?',
        whereArgs: [id],
      );
      showSuccessSnackBar(message: "Succesfully Deleted The Category");
    } on Exception catch (e) {
      showErrorSnackBar(
        message: "Error: While Deleting The Category \nERROR:${e.toString()}",
      );
    } finally {
      setLoading(false);
    }
  }
}

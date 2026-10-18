import 'package:flutter/foundation.dart';
import 'package:flutter_general_reviewer/models/app_category.dart';
import 'package:flutter_general_reviewer/services/database_service.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class CategoryRepository extends GetxController {
  Database get db => Get.find<DatabaseService>().db;

  // CRUD Operations
  // Create Operation For Table
  Future<void> addCategory(AppCategory category) async {
    try {
      await db.insert(DBConstants.categoryTable, category.toMap());
    } catch (e) {
      debugPrint(
        "Error: while creating the category: \nERRROR: ${e.toString()}",
      );
    }
  }

  // Read Operation For Categories
  Future<List<AppCategory>> getCategories({int? categoryParentId}) async {
    try {
      final data = await db.query(
        DBConstants.categoryTable,
        where: categoryParentId != null
            ? '${DBConstants.categoryParentId} = ?'
            : '${DBConstants.categoryParentId} IS NULL',
        whereArgs: categoryParentId != null ? [categoryParentId] : null,
      );
      List<AppCategory> categories = data
          .map((e) => AppCategory.fromMap(e))
          .toList();
      return categories;
    } catch (e) {
      debugPrint(
        "Error: while getting the category: \nERRROR: ${e.toString()}",
      );
      return List.empty();
    }
  }

  // Update Operation for Category
  Future<void> updateCategory(AppCategory category) async {
    try {
      await db.update(
        DBConstants.categoryTable,
        category.toMap(),
        where: '${DBConstants.categoryId} = ?',
        whereArgs: [category.id],
      );
    } catch (e) {
      debugPrint(
        "Error: while updating the category: \nERRROR: ${e.toString()}",
      );
    }
  }

  // Delete operation for category
  Future<void> deleteCategory(int id) async {
    try {
      await db.delete(
        DBConstants.categoryTable,
        where: '${DBConstants.categoryId} = ?',
        whereArgs: [id],
      );
    } catch (e) {
      debugPrint(
        "Error: while deleting the category: \nERRROR: ${e.toString()}",
      );
    }
  }
}

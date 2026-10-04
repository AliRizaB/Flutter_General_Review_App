// After Debug remove foundation.dart

import 'package:flutter/foundation.dart';
import 'package:flutter_general_reviewer/base/base_controller.dart';
import 'package:flutter_general_reviewer/models/app_category.dart';
import 'package:flutter_general_reviewer/repository/category_repo.dart';
import 'package:get/get.dart';

class CategoryController extends BaseController {
  final CategoryRepository _categoryRepository = Get.find<CategoryRepository>();
  RxList<AppCategory> categories = <AppCategory>[].obs;

  @override
  void onInit() {
    super.onInit();
    setLoading(true);
    fetchCategories();
    setLoading(false);
  }

  Future<void> fetchCategories() async {
    try {
      final list = await _categoryRepository.getCategories();
      categories.assignAll(list);
    } catch (e) {
      debugPrint("Error: While Getting Categories");
    }
  }

  Future<void> addCategory(AppCategory category) async {
    try {
      setLoading(true);
      await _categoryRepository.addCategory(category);
      await fetchCategories();
      showSuccessSnackBar(message: "Succesfully Created Category");
    } catch (e) {
      showErrorSnackBar(
        message: "Error: While Creating Categories \nERROR:${e.toString()}",
      );
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateCategory(AppCategory category) async {
    try {
      setLoading(true);
      await _categoryRepository.updateCategory(category);
      await fetchCategories();
      showSuccessSnackBar(message: "Succesfully Updated Category");
    } catch (e) {
      showErrorSnackBar(
        message: "Error: While Updating Categories \nERROR:${e.toString()}",
      );
    } finally {
      setLoading(false);
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      setLoading(true);
      await _categoryRepository.deleteCategory(id);
      await fetchCategories();
      showSuccessSnackBar(message: "Succesfully Deleted Category");
    } catch (e) {
      showErrorSnackBar(
        message: "Error: While Deleting Categories \nERROR:${e.toString()}",
      );
    } finally {
      setLoading(false);
    }
  }
}

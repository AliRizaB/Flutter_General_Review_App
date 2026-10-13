// After Debug remove foundation.dart

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_general_reviewer/base/base_controller.dart';
import 'package:flutter_general_reviewer/models/app_category.dart';
import 'package:flutter_general_reviewer/repository/category_repo.dart';
import 'package:get/get.dart';

class CategoryController extends BaseController {
  final CategoryRepository _categoryRepository = Get.find<CategoryRepository>();
  RxList<AppCategory> categories = <AppCategory>[].obs;

  // AppCategory attributes
  int? categoryId;
  Rx<String> categoryName = ''.obs;
  Rx<Color> categoryColor = const Color(0xff443a49).obs;

  @override
  void onInit() {
    super.onInit();
    setLoading(true);
    fetchCategories();
    setLoading(false);
  }

  void initCategoryForm(AppCategory? category) {
    if (category != null) {
      categoryId = category.id;
      categoryName.value = category.name;
      categoryColor.value = category.getColor;
    } else {
      categoryName.value = '';
      categoryColor.value = const Color(0xff443a49);
    }
  }

  // CRUD OPERATIONS
  Future<void> fetchCategories() async {
    try {
      final list = await _categoryRepository.getCategories();
      categories.assignAll(list);
    } catch (e) {
      debugPrint("Error: While Getting Categories");
    }
  }

  Future<void> addCategory() async {
    try {
      setLoading(true);
      final newCategory = AppCategory(
        name: categoryName.value,
        color: categoryColor.value.hex,
      );

      await _categoryRepository.addCategory(newCategory);
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

  Future<void> updateCategory() async {
    try {
      setLoading(true);
      final updatedCategory = AppCategory(
        id: categoryId,
        name: categoryName.value,
        color: categoryColor.value.hex,
      );

      await _categoryRepository.updateCategory(updatedCategory);
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

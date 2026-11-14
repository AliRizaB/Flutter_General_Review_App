// Essential
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_general_reviewer/base/base_controller.dart';
import 'package:flutter_general_reviewer/repositories/category_repo.dart';

// Helper Package
import 'package:flex_color_picker/flex_color_picker.dart';

// Model
import 'package:flutter_general_reviewer/models/app_category.dart';

class CategoryController extends BaseController {
  final CategoryRepository _categoryRepository = Get.find<CategoryRepository>();
  RxList<AppCategory> categories = <AppCategory>[].obs;

  // AppCategory attributes
  int? categoryId;
  Rx<int?> categoryParentId = (null as int?).obs;
  Rx<String> categoryName = ''.obs;
  Rx<Color> categoryColor = const Color(0xff443a49).obs;

  // Parent Handlers
  bool get canEditParentCategory => false;
  List<AppCategory> parentCategories = [];

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  void initCategoryForm(AppCategory? category) {
    categoryId = category?.id;
    categoryParentId.value = category?.parentId;
    categoryName.value = category?.name ?? '';
    categoryColor.value = category?.getColor ?? const Color(0xff443a49);
  }

  Future<void> saveCategory() async {
    if (categoryId != null) {
      await updateCategory();
    } else {
      await addCategory();
    }
  }

  // CRUD OPERATIONS
  Future<void> fetchCategories({int? categoryParentId}) async {
    await super.runAction(
      action: () async {
        final targetParentId = categoryParentId ?? this.categoryParentId.value;
        final list = await _categoryRepository.getCategories(
          categoryParentId: targetParentId,
        );
        categories.assignAll(list);
      },
      errorMsg: "Error: While Getting Categories",
      loading: false,
    );
  }

  Future<void> addCategory() async {
    await super.runAction(
      action: () async {
        final newCategory = AppCategory(
          name: categoryName.value,
          color: categoryColor.value.hex,
          parentId: categoryParentId.value,
        );

        await _categoryRepository.addCategory(newCategory);
        await fetchCategories();
      },
      errorMsg: "Error: While Creating Category",
      successMsg: "Succesfully Created Category",
    );
  }

  Future<void> updateCategory() async {
    await super.runAction(
      action: () async {
        final updatedCategory = AppCategory(
          id: categoryId,
          name: categoryName.value,
          color: categoryColor.value.hex,
          parentId: categoryParentId.value,
        );

        await _categoryRepository.updateCategory(updatedCategory);
        await fetchCategories();
      },
      errorMsg: "Error: While Updating Category",
      successMsg: "Succesfully Updated Category",
    );
  }

  Future<void> deleteCategory(int id) async {
    await super.runAction(
      action: () async {
        await _categoryRepository.deleteCategory(id);
        await fetchCategories();
      },
      errorMsg: "Error: While Deleting Category",
      successMsg: "Succesfully Deleted Category",
    );
  }
}

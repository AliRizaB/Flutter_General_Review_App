// Essentials
import 'package:get/get.dart';
import 'package:flutter_general_reviewer/modules/category/category_controller.dart';
import 'package:flutter_general_reviewer/repositories/category_repo.dart';

// Model
import 'package:flutter_general_reviewer/models/app_category.dart';

class SubCategoryController extends CategoryController {
  Rx<int?> parentId = (null as int?).obs;

  late final String parentName;
  final CategoryRepository _categoryRepository = Get.find<CategoryRepository>();

  @override
  void onInit() {
    _parseArguments();
    categoryParentId.value = parentId.value;
    getParentCategories();
    super.onInit();
  }

  void _parseArguments() {
    if (Get.arguments != null && Get.arguments is List) {
      final args = Get.arguments as List;
      parentId.value = args[0] as int?;
      parentName = (args.length > 1 && args[1] != null)
          ? args[1] as String
          : 'Sub Category';
    } else {
      parentName = 'Sub Category';
    }
  }

  @override
  void initCategoryForm(AppCategory? category) {
    super.initCategoryForm(category);
    if (category == null) {
      categoryParentId.value = parentId.value;
    }
  }

  Future<void> getParentCategories() async {
    await super.runAction(
      action: () async {
        parentCategories = await _categoryRepository.getCategories(
          categoryParentId: null,
        );
      },
      errorMsg: "Error: While Getting Parent Categories",
      loading: false,
    );
  }
}

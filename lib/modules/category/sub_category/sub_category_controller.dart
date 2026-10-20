import 'package:flutter_general_reviewer/models/app_category.dart';
import 'package:flutter_general_reviewer/modules/category/category_controller.dart';
import 'package:flutter_general_reviewer/repository/category_repo.dart';
import 'package:get/get.dart';

class SubCategoryController extends CategoryController {
  Rx<int?> parentId = (null as int?).obs;

  late final String parentName;
  RxList<AppCategory> parentCategories = <AppCategory>[].obs;
  final CategoryRepository _categoryRepository = Get.find<CategoryRepository>();

  @override
  void onInit() {
    if (Get.arguments != null && Get.arguments is List) {
      final args = Get.arguments as List;
      parentId.value = args[0] as int?;
      parentName = (args.length > 1 && args[1] != null)
          ? args[1] as String
          : 'Sub Category';
    } else {
      parentName = 'Sub Category';
    }
    categoryParentId.value = parentId.value;

    getParentCategories();

    super.onInit();
  }

  @override
  void initCategoryForm(AppCategory? category) {
    super.initCategoryForm(category);
    if (category == null) {
      categoryParentId.value = parentId.value;
    }
  }

  Future<void> getParentCategories() async {
    try {
      final list = await _categoryRepository.getCategories(
        categoryParentId: null,
      );
      parentCategories.assignAll(list);
    } catch (e) {
      showErrorSnackBar(message: "Error: While Getting Categories");
    }
  }
}

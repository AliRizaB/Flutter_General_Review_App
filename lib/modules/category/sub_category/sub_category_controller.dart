import 'package:flutter_general_reviewer/models/app_category.dart';
import 'package:flutter_general_reviewer/modules/category/category_controller.dart';
import 'package:get/route_manager.dart';

class SubCategoryController extends CategoryController {
  late final int? parentId;
  late final String parentName;

  @override
  void onInit() {
    final args = Get.arguments as List;
    parentId = args[0] as int?;
    parentName = args[1] as String;
    
    categoryParentId = parentId;
    super.onInit();
    fetchCategories(categoryParentId: categoryParentId);
  }

  @override
  void initCategoryForm(AppCategory? category) {
    super.initCategoryForm(category);
    if (category == null) {
      categoryParentId = parentId;
    }
  }
}

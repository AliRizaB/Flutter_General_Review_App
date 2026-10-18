import 'package:flutter_general_reviewer/modules/category/sub_category/sub_category_controller.dart';
import 'package:get/instance_manager.dart';

class SubCategoryBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => SubCategoryController(),);
  }

}
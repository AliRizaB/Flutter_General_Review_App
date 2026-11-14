import 'package:flutter_general_reviewer/base/base_controller.dart';
import 'package:flutter_general_reviewer/modules/category/category_controller.dart';
import 'package:flutter_general_reviewer/modules/home/home_controller.dart';
import 'package:flutter_general_reviewer/repositories/category_repo.dart';
import 'package:get/instance_manager.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());
    Get.put<CategoryRepository>(CategoryRepository());
    Get.put<CategoryController>(CategoryController());
    Get.lazyPut(() => BaseController());
  }
}

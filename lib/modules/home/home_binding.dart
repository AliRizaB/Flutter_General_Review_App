import 'package:flutter_general_reviewer/modules/home/home_controller.dart';
import 'package:flutter_general_reviewer/repository/category_repo.dart';
import 'package:get/instance_manager.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut(() => CategoryRepository(),);
  }
}

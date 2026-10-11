import 'package:flutter_general_reviewer/modules/review/review_controller.dart';
import 'package:flutter_general_reviewer/repository/review_repo.dart';
import 'package:get/instance_manager.dart';

class ReviewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReviewController());
    Get.lazyPut(() => ReviewRepository());
  }
}

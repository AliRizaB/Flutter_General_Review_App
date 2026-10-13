import 'package:flutter_general_reviewer/modules/status/status_controller.dart';
import 'package:flutter_general_reviewer/repository/status_repo.dart';
import 'package:get/instance_manager.dart';

class StatusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StatusRepository());
    Get.lazyPut(() => StatusController());
  }
}

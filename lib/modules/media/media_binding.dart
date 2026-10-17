import 'package:flutter_general_reviewer/modules/status/status_controller.dart';
import 'package:flutter_general_reviewer/modules/media/media_controller.dart';
import 'package:flutter_general_reviewer/repository/media_repo.dart';
import 'package:flutter_general_reviewer/repository/status_repo.dart';
import 'package:flutter_general_reviewer/services/api_service.dart';
import 'package:get/get.dart';

class MediaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MediaRepository());
    Get.lazyPut(() => StatusRepository());

    Get.lazyPut(() => MediaController());
    Get.lazyPut(() => StatusController());

    Get.lazyPut(() => ApiService());
  }
}

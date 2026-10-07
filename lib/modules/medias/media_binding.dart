import 'package:flutter_general_reviewer/modules/medias/media_controller.dart';
import 'package:flutter_general_reviewer/repository/media_repo.dart';
import 'package:flutter_general_reviewer/repository/status_repo.dart';
import 'package:get/get.dart';

class MediaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MediaRepository());
    Get.lazyPut(() => StatusRepository());
    Get.lazyPut(() => MediaController());
  }
}

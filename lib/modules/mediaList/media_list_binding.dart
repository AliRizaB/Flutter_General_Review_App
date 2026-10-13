import 'package:flutter_general_reviewer/modules/status/status_controller.dart';
import 'package:flutter_general_reviewer/modules/mediaList/media_list_controller.dart';
import 'package:flutter_general_reviewer/repository/media_repo.dart';
import 'package:flutter_general_reviewer/repository/status_repo.dart';
import 'package:get/get.dart';

class MediaListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MediaRepository());
    Get.lazyPut(() => StatusRepository());

    Get.lazyPut(() => MediaListController());
    Get.lazyPut(() => StatusController());
  }
}

import 'package:flutter_general_reviewer/base/base_controller.dart';
import 'package:flutter_general_reviewer/routes/app_pages.dart';
import 'package:flutter_general_reviewer/services/database_service.dart';
import 'package:get/get.dart';

class SplashController extends BaseController {
  @override
  void onReady() async {
    super.onReady();

    await waitForServices();

    Get.offAllNamed(AppRoutes.HOME);
  }

  Future<void> waitForServices() async {
    while (!Get.isRegistered<DatabaseService>()) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }
}

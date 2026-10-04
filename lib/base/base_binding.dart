import 'package:flutter_general_reviewer/services/database_service.dart';
import 'package:get/instance_manager.dart';

class BaseBinding extends Bindings {
  @override
  void dependencies() {
    Get.putAsync(() async {
      final service = DatabaseService();
      await service.init();
      return service;
    }, permanent: true);
  }
}

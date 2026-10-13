import 'package:flutter_general_reviewer/services/database_service.dart';
import 'package:get/get.dart';

class BaseBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    await Get.putAsync<DatabaseService>(
      () => DatabaseService().init(),
      permanent: true,
    );
  }
}

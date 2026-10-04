import 'package:flutter_general_reviewer/base/base_controller.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class HomeController extends BaseController {
  final currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
  }
}

// ignore_for_file: avoid_print

import 'package:flutter_general_reviewer/base/base_controller.dart';
import 'package:flutter_general_reviewer/models/app_category.dart';
import 'package:flutter_general_reviewer/repository/category_repo.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/instance_manager.dart';

class HomeController extends BaseController {
  final CategoryRepository _categoryRepository = Get.find<CategoryRepository>();
  RxList<AppCategory> categories = <AppCategory>[].obs;

  @override
  void onInit() async {
    super.onInit();
    await fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      setLoading(true);
      final list = await _categoryRepository.getCategories();
      categories.value = list;
    } catch (e) {
      print("Error: While Getting Categories");
    } finally {
      setLoading(false);
    }
  }

  Future<void> createCategory(AppCategory category) async {
    try {
      setLoading(true);
      await _categoryRepository.addCategory(category);
      fetchCategories();
      showSuccessSnackBar(message: "Succesfully Created Category");
    } catch (e) {
      showErrorSnackBar(
        message: "Error: While Creating Categories \nERROR:${e.toString()}",
      );
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateCategory(AppCategory category) async {
    try {
      setLoading(true);
      await _categoryRepository.updateCategory(category);
      fetchCategories();
      showSuccessSnackBar(message: "Succesfully Updated Category");
    } catch (e) {
      showErrorSnackBar(
        message: "Error: While Updating Categories \nERROR:${e.toString()}",
      );
    } finally {
      setLoading(false);
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      setLoading(true);
      await _categoryRepository.deleteCategory(id);
      fetchCategories();
      showSuccessSnackBar(message: "Succesfully Deleted Category");
    } catch (e) {
      showErrorSnackBar(
        message: "Error: While Deleting Categories \nERROR:${e.toString()}",
      );
    } finally {
      setLoading(false);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/models/app_category.dart';
import 'package:flutter_general_reviewer/modules/home/widget/dialog_add_category.dart';
import 'package:get/get.dart';

Future<bool?> confirmDialog(
  DismissDirection direction,
  AppCategory currentCategory,
  BuildContext context,
) async {
  if (direction == DismissDirection.endToStart) {
    return await Get.defaultDialog<bool>(
      title: "Delete Category",
      middleText: "You want to delete the ${currentCategory.name}",
      textConfirm: "Confirm",
      textCancel: "Cancel",
      confirmTextColor: Colors.black,
      onConfirm: () {
        Get.back(result: true);
      },
      onCancel: () {
        Get.back(result: false);
      },
    );
  } else {
    showAddCategoryDialog(context, toUpdateCategory: currentCategory);
    return false;
  }
}

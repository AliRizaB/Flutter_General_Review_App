import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/models/app_category.dart';
import 'package:flutter_general_reviewer/modules/category/widget/dialog_add_category.dart';
import 'package:get/get.dart';

Future<bool?> handleDismiss(
  DismissDirection direction,
  AppCategory currentCategory,
  BuildContext context,
) async {
  final theme = Theme.of(context);
  if (direction == DismissDirection.endToStart) {
    return await Get.defaultDialog<bool>(
      backgroundColor: theme.colorScheme.error,
      content: Text(
        'Are you sure?',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      ),

      confirmTextColor: Colors.white,
      textConfirm: 'YES',
      onConfirm: () {
        Get.back(result: true);
      },

      buttonColor: theme.colorScheme.onError,

      cancelTextColor: Colors.white,
      textCancel: 'no',
      onCancel: () => false,

      title: "Delete \"${currentCategory.name}\"",
    );
  } else {
    showAddCategoryDialog(context, toUpdateCategory: currentCategory);
    return false;
  }
}

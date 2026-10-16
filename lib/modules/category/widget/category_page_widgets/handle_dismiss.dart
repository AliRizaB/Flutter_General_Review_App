import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/Utilities/general_widgets/delete_confirmation.dart';
import 'package:flutter_general_reviewer/models/app_category.dart';
import 'package:flutter_general_reviewer/modules/category/widget/add_dialog_category.dart';

Future<bool?> handleDismiss(
  DismissDirection direction,
  AppCategory currentCategory,
  BuildContext context,
) async {
  final theme = Theme.of(context);
  if (direction == DismissDirection.endToStart) {
    return await deleteConfirmDialog(theme, title: currentCategory.name);
  } else {
    showAddCategoryDialog(context, toUpdateCategory: currentCategory);
    return false;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/category/widget/dialog_add_category.dart';

AppBar homeAppBar(BuildContext context) {
  final theme = Theme.of(context);
  return AppBar(
    backgroundColor: theme.colorScheme.primary,
    title: Text(
      "Review App",
      style: theme.textTheme.headlineMedium!.copyWith(fontFamily: 'Isometra'),
    ),
    actions: [
      IconButton(
        onPressed: () async => showAddCategoryDialog(context),
        icon: Icon(Icons.add, size: 30),
      ),
    ],
  );
}

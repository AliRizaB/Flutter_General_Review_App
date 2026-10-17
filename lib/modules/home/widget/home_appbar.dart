import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/utilities/app_bar_theme.dart';
import 'package:flutter_general_reviewer/modules/category/widget/category_dialog.dart';

AppBar homeAppBar(BuildContext context) {
  final theme = Theme.of(context);
  return AppBar(
    backgroundColor: getAppBarColor(theme),
    foregroundColor: getAppBarForegroundColor(theme),
    title: Text(
      "Review App",
      style: theme.textTheme.headlineMedium!.copyWith(
        color: getAppBarForegroundColor(theme),
        fontFamily: 'Isometra',
      ),
    ),
    actions: [
      IconButton(
        onPressed: () async => showCategoryDialog(context),
        icon: Icon(Icons.add, size: 30),
      ),
    ],
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/home/widget/dialog_add_category.dart';

AppBar homeAppBar(BuildContext context) {
  return AppBar(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Review App",
          style: TextStyle(fontFamily: 'Isometra', fontSize: 25),
        ),
        IconButton(
          onPressed: () async => showAddCategoryDialog(context),
          icon: Icon(Icons.add, size: 30),
        ),
      ],
    ),
    backgroundColor: Theme.of(context).colorScheme.onSecondary,
  );
}

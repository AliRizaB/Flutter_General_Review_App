import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/category/widget/dialog_category.dart';
import 'package:flutter_general_reviewer/modules/z_general_widgets/dissmissible/build_swipe_background.dart';
import 'package:flutter_general_reviewer/modules/z_general_widgets/empty_state.dart';
import 'package:flutter_general_reviewer/modules/category/category_controller.dart';
import 'package:flutter_general_reviewer/modules/category/widget/category_tile.dart';
import 'package:flutter_general_reviewer/modules/z_general_widgets/dissmissible/handle_dismiss.dart';
import 'package:get/get.dart';

class CategoryPage extends GetView<CategoryController> {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(() {
      final categories = controller.categories;
      if (categories.isEmpty) {
        return EmptyState(
          icon: Icons.cabin,
          title: 'There is no Categories',
          subtitle: 'Please Add A category via top right icon',
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: categories.length,
        separatorBuilder: (context, index) {
          return Divider(height: 16);
        },

        itemBuilder: (context, index) {
          final category = categories[index];

          return Dismissible(
            key: ValueKey(category.id ?? index),

            direction: DismissDirection.horizontal,

            confirmDismiss: (direction) async {
              if (category.id == null) {
                controller.showErrorSnackBar(
                  message: 'CategoryId can not be null',
                );
                return false;
              }
              return handleDismiss(
                context: context,
                direction: direction,
                itemTitle: 'Category',
                onDelete: () => controller.deleteCategory(category.id!),
                onEdit: () =>
                    showCategoryDialog(context, toUpdateCategory: category),
              );
            },

            secondaryBackground: buildSwipeBackground(
              color: Theme.of(context).colorScheme.errorContainer,
              icon: Icons.delete,
              alignment: Alignment.centerRight,
            ),

            background: buildSwipeBackground(
              color: theme.colorScheme.secondaryContainer,
              icon: Icons.edit,
              alignment: Alignment.centerLeft,
            ),

            child: CategoryTile(category: category),
          );
        },
      );
    });
  }
}

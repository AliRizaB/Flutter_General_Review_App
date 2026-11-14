// Essentials
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_general_reviewer/modules/category/category_controller.dart';

// Used Widgets
import 'package:flutter_general_reviewer/modules/shared/dissmissible/swipeable_item.dart';
import 'package:flutter_general_reviewer/modules/shared/empty_state.dart';
import 'package:flutter_general_reviewer/modules/category/widgets/category_tile.dart';

// Routing
import 'package:flutter_general_reviewer/modules/category/widgets/category_dialog.dart';
import 'package:flutter_general_reviewer/routes/app_pages.dart';

class CategoryPage extends GetView<CategoryController> {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = controller.categories;

    return Obx(() {
      if (categories.isEmpty) {
        return EmptyState(
          icon: Icons.shelves,
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

          return SwipeableItem(
            itemKey: ValueKey(category.id ?? index),
            itemTitle: 'Category',
            onDelete: () => controller.deleteCategory(category.id!),
            onEdit: () => showCategoryDialog<CategoryController>(
              'Category',
              'Movies, Game, Book',
              toUpdateCategory: category,
            ),
            swipeItem: CategoryTile(
              category: category,
              fontSize: 25,
              iconSize: 30,
              dense: false,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              onTap: () {
                Get.toNamed(
                  AppRoutes.SUBCATEGORIES,
                  arguments: [category.id, category.name],
                );
              },
            ),
          );
        },
      );
    });
  }
}

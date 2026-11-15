// Essentials
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Controller
import 'package:flutter_general_reviewer/modules/category/sub_category/sub_category_controller.dart';

// Used Wigdets
import 'package:flutter_general_reviewer/modules/shared/dissmissible/swipeable_item.dart';
import 'package:flutter_general_reviewer/modules/shared/appbar_base.dart';
import 'package:flutter_general_reviewer/modules/shared/empty_state.dart';
import 'package:flutter_general_reviewer/modules/category/widgets/category_tile.dart';

// Routing
import 'package:flutter_general_reviewer/modules/category/widgets/category_dialog.dart';
import 'package:flutter_general_reviewer/routes/app_pages.dart';

class SubCategoryPage extends GetView<SubCategoryController> {
  const SubCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = controller.categories;

    return Scaffold(
      appBar: AppBarBase(
        title: controller.parentName,
        actions: [
          IconButton(
            onPressed: () => showCategoryDialog<SubCategoryController>(
              'Sub-Category',
              'Action, Horror, Sci-fi, ...',
            ),
            icon: const Icon(Icons.add, size: 30),
          ),
        ],
      ),
      body: Obx(() {
        if (categories.isEmpty) {
          return EmptyState(
            icon: Icons.grid_view,
            title: 'There is no Sub-Categories',
            subtitle: 'Please Add A sub-category via top right icon',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: categories.length,
          separatorBuilder: (context, index) {
            return Divider(height: 8);
          },

          itemBuilder: (context, index) {
            final category = categories[index];

            return SwipeableItem(
              itemKey: ValueKey(category.id ?? index),
              itemTitle: "Sub-Category",
              onDeleted: () => controller.deleteCategory(category.id!),
              onEdited: () => showCategoryDialog<SubCategoryController>(
                'Sub-Category',
                '',
                toUpdateCategory: category,
              ),
              swipeItem: CategoryTile(
                category: category,
                fontSize: 20,
                iconSize: 15,
                dense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                onTap: () {
                  Get.toNamed(
                    AppRoutes.MEDIAS,
                    arguments: [category.id, category.name],
                  );
                },
              ),
            );
          },
        );
      }),
    );
  }
}

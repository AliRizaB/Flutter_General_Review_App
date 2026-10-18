import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/category/sub_category/sub_category_controller.dart';
import 'package:flutter_general_reviewer/modules/category/widget/category_dialog.dart';
import 'package:flutter_general_reviewer/modules/z_general_widgets/appbar_base.dart';
import 'package:flutter_general_reviewer/modules/z_general_widgets/dissmissible/build_swipe_background.dart';
import 'package:flutter_general_reviewer/modules/z_general_widgets/empty_state.dart';
import 'package:flutter_general_reviewer/modules/category/widget/category_tile.dart';
import 'package:flutter_general_reviewer/modules/z_general_widgets/dissmissible/handle_dismiss.dart';
import 'package:flutter_general_reviewer/routes/app_pages.dart';
import 'package:get/get.dart';

class SubCategoryPage extends GetView<SubCategoryController> {
  const SubCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categories = controller.categories;

    return Scaffold(
      appBar: AppBarBase(
        title: controller.parentName,
        actions: [
          IconButton(
            onPressed: () => showCategoryDialog<SubCategoryController>(
              'Sub-Category',
              '',
              context,
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

            return Dismissible(
              key: ValueKey(category.id ?? index),

              direction: DismissDirection.horizontal,

              confirmDismiss: (direction) async {
                if (category.id == null) {
                  controller.showErrorSnackBar(
                    message: 'Sub-CategoryId can not be null',
                  );
                  return false;
                }
                return handleDismiss(
                  context: context,
                  direction: direction,
                  itemTitle: 'Sub-Category',
                  onDelete: () => controller.deleteCategory(category.id!),
                  onEdit: () => showCategoryDialog<SubCategoryController>(
                    'Sub-Category',
                    '',
                    context,
                    toUpdateCategory: category,
                  ),
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

              child: CategoryTile(
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

import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/Utilities/general_widgets/empty_state.dart';
import 'package:flutter_general_reviewer/modules/category/category_controller.dart';
import 'package:flutter_general_reviewer/modules/category/widget/category_page_widgets/background_container.dart';
import 'package:flutter_general_reviewer/modules/category/widget/category_page_widgets/category_tile.dart';
import 'package:flutter_general_reviewer/modules/category/widget/category_page_widgets/handle_dismiss.dart';
import 'package:get/get.dart';

class CategoryPage extends GetView<CategoryController> {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.categories.isEmpty) {
        return EmptyState(
          icon: Icons.cabin,
          title: 'There is no Categories',
          subtitle: 'Please Add A category via top right icon',
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: controller.categories.length,
        separatorBuilder: (context, index) {
          return Divider(height: 16);
        },

        itemBuilder: (context, index) {
          final currentCategory = controller.categories[index];

          return Dismissible(
            key: ValueKey(currentCategory.id),

            direction: DismissDirection.horizontal,

            confirmDismiss: (direction) async {
              final isConfirmed = await handleDismiss(
                direction,
                currentCategory,
                context,
              );

              if (direction == DismissDirection.endToStart &&
                  isConfirmed == true) {
                if (currentCategory.id != null) {
                  await controller.deleteCategory(currentCategory.id!);
                }
                return true;
              }

              return false;
            },

            secondaryBackground: backgroundContainer(
              color: Theme.of(context).colorScheme.errorContainer,
              icon: Icon(Icons.delete),
              alignment: Alignment.centerRight,
            ),

            background: backgroundContainer(
              color: Theme.of(context).colorScheme.secondaryContainer,
              icon: Icon(Icons.edit),
              alignment: Alignment.centerLeft,
            ),

            child: CategoryTile(category: currentCategory),
          );
        },
      );
    });
  }
}

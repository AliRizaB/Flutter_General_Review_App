import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/category/category_controller.dart';
import 'package:flutter_general_reviewer/modules/category/widget/background_container.dart';
import 'package:flutter_general_reviewer/modules/category/widget/confirm_dialog.dart';
import 'package:flutter_general_reviewer/routes/app_pages.dart';
import 'package:get/get.dart';

class CategoryList extends GetView<CategoryController> {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.categories.isEmpty) {
        return Card(
          child: ListTile(
            title: Text('There is no Categories'),
            subtitle: Text('Please Add A category via top right icon'),
          ),
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
              final isConfirmed = await confirmDialog(
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
              icon: Icon(Icons.delete, color: Colors.black87),
              alignment: Alignment.centerRight,
            ),

            background: backgroundContainer(
              color: Theme.of(context).colorScheme.onPrimary,
              icon: Icon(Icons.system_security_update, color: Colors.black87),
              alignment: Alignment.centerLeft,
            ),

            child: ListTile(
              onTap: () {
                Get.toNamed(
                  AppRoutes.MEDIA,
                  arguments: [currentCategory.id, currentCategory.name],
                );
              },

              title: Text(
                currentCategory.name,
                style: TextStyle(
                  fontFamily: 'Isometra',
                  fontSize: 25,
                  color: currentCategory.contrastTextColor,
                ),
              ),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: currentCategory.contrastTextColor.withValues(
                    alpha: 0.4,
                  ),
                  width: 1.5,
                ),
              ),

              tileColor: currentCategory.getColor,
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 30,
                color: currentCategory.contrastTextColor,
              ),
            ),
          );
        },
      );
    });
  }
}

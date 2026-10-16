import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/utilities/general_widgets/build_swipe_background.dart';
import 'package:flutter_general_reviewer/utilities/app_bar_theme.dart';
import 'package:flutter_general_reviewer/utilities/general_widgets/empty_state.dart';
import 'package:flutter_general_reviewer/modules/status/status_controller.dart';
import 'package:flutter_general_reviewer/modules/status/widgets/status_dialog.dart';
import 'package:flutter_general_reviewer/modules/status/widgets/status_tile.dart';
import 'package:flutter_general_reviewer/utilities/general_widgets/handle_dismiss.dart';
import 'package:get/get.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StatusController>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: getAppBarColor(theme),
        foregroundColor: getAppBarForegroundColor(theme),
        title: Text(
          'Statuses',
          style: theme.textTheme.headlineMedium!.copyWith(
            color: getAppBarForegroundColor(theme),
            fontFamily: 'Isometra',
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => showStatusDialog(context),
            icon: const Icon(Icons.add, size: 30),
          ),
        ],
      ),
      body: Obx(() {
        final statuses = controller.statuses;

        if (statuses.isEmpty) {
          return EmptyState(
            icon: Icons.rate_review_outlined,
            title: 'No Status',
            subtitle:
                'Tap the icon in the top right to write your first review.',
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: statuses.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final status = statuses[index];

            return Dismissible(
              key: ValueKey(status.id ?? index),
              direction: DismissDirection.horizontal,
              confirmDismiss: (direction) async {
                if (status.id == null) {
                  controller.showErrorSnackBar(
                    message: 'Review Id can not be Null',
                  );
                  return false;
                }

                return handleDismiss(
                  context: context,
                  direction: direction,
                  itemTitle: 'Review',
                  onDelete: () => controller.deleteStatus(status.id!),
                  onEdit: () =>
                      showStatusDialog(context, toUpdateStatus: status),
                );
              },
              background: buildSwipeBackground(
                color: theme.colorScheme.inversePrimary,
                icon: Icons.edit_outlined,
                alignment: Alignment.centerLeft,
              ),
              secondaryBackground: buildSwipeBackground(
                color: theme.colorScheme.errorContainer,
                icon: Icons.delete_outline,
                alignment: Alignment.centerRight,
              ),
              child: StatusTile(status: status),
            );
          },
        );
      }),
    );
  }
}

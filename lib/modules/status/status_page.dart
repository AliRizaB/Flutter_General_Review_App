import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/Utilities/app_bar_theme.dart';
import 'package:flutter_general_reviewer/Utilities/general_widgets/delete_confirmation.dart';
import 'package:flutter_general_reviewer/Utilities/general_widgets/empty_state.dart';
import 'package:flutter_general_reviewer/models/media_status.dart';
import 'package:flutter_general_reviewer/modules/status/status_controller.dart';
import 'package:flutter_general_reviewer/modules/status/widgets/status_dialog.dart';
import 'package:flutter_general_reviewer/modules/status/widgets/status_tile.dart';
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
              confirmDismiss: (direction) =>
                  _handleDismiss(context, direction, status, controller, theme),
              background: _buildSwipeBackground(
                theme: theme,
                color: theme.colorScheme.inversePrimary,
                icon: Icons.edit_outlined,
                alignment: Alignment.centerLeft,
              ),
              secondaryBackground: _buildSwipeBackground(
                theme: theme,
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

  /// Handles swipe actions (Edit vs Delete)
  Future<bool> _handleDismiss(
    BuildContext context,
    DismissDirection direction,
    MediaStatus status,
    StatusController controller,
    ThemeData theme,
  ) async {
    if (direction == DismissDirection.endToStart) {
      // Swipe Left -> Delete
      final confirmed = await deleteConfirmDialog(theme, title: status.name);

      if (confirmed == true && status.id != null) {
        await controller.deleteStatus(status.id!);
        return true;
      }
      return false;
    } else {
      showStatusDialog(context, toUpdateStatus: status);
      return false;
    }
  }

  Widget _buildSwipeBackground({
    required ThemeData theme,
    required Color color,
    required IconData icon,
    required Alignment alignment,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),

      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: alignment,
      child: Icon(icon),
    );
  }
}

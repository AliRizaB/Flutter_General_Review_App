import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/shared/appbar_base.dart';
import 'package:flutter_general_reviewer/modules/shared/dissmissible/swipeable_item.dart';
import 'package:flutter_general_reviewer/modules/shared/empty_state.dart';
import 'package:flutter_general_reviewer/modules/status/status_controller.dart';
import 'package:flutter_general_reviewer/modules/status/widgets/status_dialog.dart';
import 'package:flutter_general_reviewer/modules/status/widgets/status_tile.dart';
import 'package:get/get.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StatusController>();

    return Scaffold(
      appBar: AppBarBase(
        title: 'Statuses',
        actions: [
          IconButton(
            onPressed: () => showStatusDialog(),
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

            return SwipeableItem(
              itemKey: ValueKey(status.id ?? index),
              itemTitle: "Status",
              onDeleted: () => controller.deleteStatus(status.id!),
              onEdited: () => showStatusDialog(toUpdateStatus: status),
              swipeItem: StatusTile(status: status),
            );
          },
        );
      }),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/shared/dissmissible/build_swipe_background.dart';
import 'package:flutter_general_reviewer/modules/shared/dissmissible/handle_dismiss.dart';

class SwipeableItem extends StatelessWidget {
  final Key itemKey;
  final String itemTitle;
  final Future<void> Function() onDelete;
  final Future<void> Function() onEdit;
  final Widget swipeItem;
  const SwipeableItem({
    super.key,
    required this.itemKey,
    required this.itemTitle,
    required this.onDelete,
    required this.onEdit,
    required this.swipeItem,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dismissible(
      key: itemKey,

      direction: DismissDirection.horizontal,

      confirmDismiss: (direction) async {
        return handleDismiss(
          context: context,
          direction: direction,
          itemTitle: itemTitle,
          onDelete: onDelete,
          onEdit: onEdit,
        );
      },

      secondaryBackground: buildSwipeBackground(
        color: theme.colorScheme.errorContainer,
        icon: Icons.delete,
        alignment: Alignment.centerRight,
      ),

      background: buildSwipeBackground(
        color: theme.colorScheme.secondaryContainer,
        icon: Icons.edit,
        alignment: Alignment.centerLeft,
      ),

      child: swipeItem,
    );
  }
}

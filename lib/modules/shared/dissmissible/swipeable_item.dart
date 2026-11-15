import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/shared/dissmissible/dissmiss_functions.dart';

class SwipeableItem extends StatelessWidget {
  final Key itemKey;
  final String itemTitle;
  final Future<void> Function() onDeleted;
  final Future<void> Function() onEdited;
  final Widget swipeItem;
  const SwipeableItem({
    super.key,
    required this.itemKey,
    required this.itemTitle,
    required this.onDeleted,
    required this.onEdited,
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
          onDelete: onDeleted,
          onEdit: onEdited,
        );
      },

      secondaryBackground: SwipeBackground(
        color: theme.colorScheme.errorContainer,
        icon: Icons.delete,
        alignment: Alignment.centerRight,
      ),

      background: SwipeBackground(
        color: theme.colorScheme.secondaryContainer,
        icon: Icons.edit,
        alignment: Alignment.centerLeft,
      ),

      child: swipeItem,
    );
  }
}

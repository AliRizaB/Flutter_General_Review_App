import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/models/media_status.dart';

class StatusTile extends StatelessWidget {
  final MediaStatus status;

  const StatusTile({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),

      color: theme.colorScheme.primaryContainer,

      child: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Container(
          padding: EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: theme.colorScheme.surface,
          ),
          alignment: Alignment.center,
          child: Text(
            status.name,
            style: theme.textTheme.bodyLarge?.copyWith(color: status.getColor),
          ),
        ),
      ),
    );
  }
}

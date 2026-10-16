import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/models/app_media.dart';

Column buildDescription(ThemeData theme, AppMedia media) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    spacing: 8,

    children: [
      Text(
        'Description:',
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          media.description ?? '',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onPrimaryContainer,
            fontSize: 18,
            height: 1.5,
          ),
        ),
      ),
    ],
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/models/app_media.dart';

class MediaDescription extends StatelessWidget {
  final AppMedia media;

  const MediaDescription({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final descriptionText = media.description.trim();

    if (descriptionText.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          'Description:',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),

          child: Text(
            descriptionText,
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
}

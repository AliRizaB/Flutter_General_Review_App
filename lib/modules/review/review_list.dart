import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/models/media_review.dart';
import 'package:flutter_general_reviewer/modules/category/widget/background_container.dart';
import 'package:flutter_general_reviewer/modules/review/review_controller.dart';
import 'package:flutter_general_reviewer/modules/review/widget/add_review_dialog.dart';
import 'package:get/get.dart';

class ReviewList extends StatelessWidget {
  const ReviewList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReviewController>();
    return Obx(() {
      final reviews = controller.reviews;

      if (reviews.isEmpty) {
        return _EmptyReviewState();
      }

      return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: reviews.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final review = reviews[index];

          return Dismissible(
            key: ValueKey(review.id ?? index),
            direction: DismissDirection.horizontal,
            confirmDismiss: (direction) =>
                _handleDismiss(context, direction, review, controller),
            background: _buildSwipeBackground(
              context: context,
              color: Theme.of(context).colorScheme.primaryContainer,
              icon: Icons.edit,
              alignment: Alignment.centerLeft,
            ),
            secondaryBackground: _buildSwipeBackground(
              context: context,
              color: Theme.of(context).colorScheme.errorContainer,
              icon: Icons.delete_outline,
              alignment: Alignment.centerRight,
            ),
            child: _ReviewTile(review: review),
          );
        },
      );
    });
  }

  /// Handles swipe actions (Edit vs Delete)
  Future<bool> _handleDismiss(
    BuildContext context,
    DismissDirection direction,
    MediaReview review,
    ReviewController controller,
  ) async {
    if (direction == DismissDirection.endToStart) {
      // Swipe Left -> Delete
      final confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: const Text('Delete Review'),
          content: const Text('Are you sure you want to delete this review?'),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Get.back(result: true),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Delete'),
            ),
          ],
        ),
      );

      if (confirmed == true && review.id != null) {
        await controller.deleteReview(review.id!);
        return true;
      }
      return false;
    } else {
      showAddReviewDialog(context, toUpdateReview: review);
      return false;
    }
  }

  Widget _buildSwipeBackground({
    required BuildContext context,
    required Color color,
    required IconData icon,
    required Alignment alignment,
  }) {
    return backgroundContainer(
      color: color,
      icon: Icon(icon, color: Theme.of(context).colorScheme.onSurface),
      alignment: alignment,
    );
  }
}

/// Empty state UI when no reviews exist
class _EmptyReviewState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rate_review_outlined,
              size: 64,
              color: theme.colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No Reviews Yet',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the icon in the top right to write your first review.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Individual Review Card Widget
class _ReviewTile extends StatelessWidget {
  final dynamic review;

  const _ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  review.date != null
                      ? '${review.date.day}/${review.date.month}/${review.date.year}'
                      : 'No Date',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              review.content,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/Utilities/app_bar_theme.dart';
import 'package:flutter_general_reviewer/Utilities/general_widgets/delete_confirmation.dart';
import 'package:flutter_general_reviewer/Utilities/general_widgets/empty_state.dart';
import 'package:flutter_general_reviewer/models/media_review.dart';
import 'package:flutter_general_reviewer/modules/review/review_controller.dart';
import 'package:flutter_general_reviewer/modules/review/widget/add_review_dialog.dart';
import 'package:flutter_general_reviewer/modules/review/widget/review_tile.dart';
import 'package:get/get.dart';

class ReviewList extends StatelessWidget {
  const ReviewList({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReviewController>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: getAppBarColor(theme),
        foregroundColor: getAppBarForegroundColor(theme),
        title: Text(
          'Reviews',
          style: theme.textTheme.headlineMedium!.copyWith(
            color: getAppBarForegroundColor(theme),
            fontFamily: 'Isometra',
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => showAddReviewDialog(context),
            icon: const Icon(Icons.add, size: 30),
          ),
        ],
      ),
      body: Obx(() {
        final reviews = controller.reviews;

        if (reviews.isEmpty) {
          return EmptyState(
            icon: Icons.rate_review_outlined,
            title: 'No Reviews',
            subtitle:
                'Tap the icon in the top right to write your first review.',
          );
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
                  _handleDismiss(context, direction, review, controller, theme),
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
              child: ReviewTile(review: review),
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
    MediaReview review,
    ReviewController controller,
    ThemeData theme,
  ) async {
    if (direction == DismissDirection.endToStart) {
      // Swipe Left -> Delete
      final confirmed = await deleteConfirmDialog(theme, title: 'review');

      if (confirmed == true && review.id != null) {
        await controller.deleteReview(review.id!);
        return true;
      }
      return false;
    } else {
      showAddReviewDialog(context, toUpdateStatus: review);
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

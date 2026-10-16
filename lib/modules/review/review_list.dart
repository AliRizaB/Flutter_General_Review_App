import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/utilities/general_widgets/build_swipe_background.dart';
import 'package:flutter_general_reviewer/utilities/general_widgets/handle_dismiss.dart';
import 'package:flutter_general_reviewer/utilities/app_bar_theme.dart';
import 'package:flutter_general_reviewer/utilities/general_widgets/empty_state.dart';
import 'package:flutter_general_reviewer/modules/review/review_controller.dart';
import 'package:flutter_general_reviewer/modules/review/widget/review_dialog.dart';
import 'package:flutter_general_reviewer/modules/review/widget/review_list_wigdets/review_tile.dart';
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
            onPressed: () => showReviewDialog(context),
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

              confirmDismiss: (direction) async {
                if (review.id == null) {
                  controller.showErrorSnackBar(
                    message: 'Review Id can not be Null',
                  );
                  return false;
                }

                return handleDismiss(
                  context: context,
                  direction: direction,
                  itemTitle: 'Review',
                  onDelete: () => controller.deleteReview(review.id!),
                  onEdit: () =>
                      showReviewDialog(context, toUpdateReview: review),
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

              child: ReviewTile(review: review),
            );
          },
        );
      }),
    );
  }

  /// Handles swipe actions (Edit vs Delete)
}

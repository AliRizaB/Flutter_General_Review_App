import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/shared/appbar_base.dart';
import 'package:flutter_general_reviewer/modules/shared/dissmissible/swipeable_item.dart';
import 'package:flutter_general_reviewer/modules/shared/empty_state.dart';
import 'package:flutter_general_reviewer/modules/review/review_controller.dart';
import 'package:flutter_general_reviewer/modules/review/widget/review_dialog.dart';
import 'package:flutter_general_reviewer/modules/review/widget/review_tile.dart';
import 'package:get/get.dart';

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReviewController>();

    return Scaffold(
      appBar: AppBarBase(
        title: 'Reviews',
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

            return SwipeableItem(
              itemKey: ValueKey(review.id ?? index),
              itemTitle: "Review",
              onDeleted: () => controller.deleteReview(review.id!),
              onEdited: () => showReviewDialog(context, toUpdateReview: review),
              swipeItem: ReviewTile(review: review),
            );
          },
        );
      }),
    );
  }

  /// Handles swipe actions (Edit vs Delete)
}

import 'package:flutter_general_reviewer/base/base_controller.dart';
import 'package:flutter_general_reviewer/models/media_review.dart';
import 'package:flutter_general_reviewer/repositories/review_repo.dart';
import 'package:get/get.dart';

class ReviewController extends BaseController {
  final ReviewRepository _reviewRepository = Get.find<ReviewRepository>();

  RxList<MediaReview> reviews = <MediaReview>[].obs;

  // Review
  int? reviewId;
  late final int mediaId;

  RxString content = ''.obs;
  DateTime date = DateTime.now();

  @override
  void onInit() {
    super.onInit();
    mediaId = Get.arguments as int;
    fetchReviews();
  }

  Future<void> onSubmit() async {
    if (reviewId != null) {
      await updateReview();
    } else {
      await addReview();
    }
  }

  // Both used for Update and Create review
  void initReviewForm(MediaReview? review) {
    reviewId = review?.id;
    content.value = review?.content ?? '';
    date = review?.date ?? DateTime.now();
  }

  // CRUD operations
  Future<void> fetchReviews() async {
    await super.runAction(
      action: () async {
        final list = await _reviewRepository.getReviews(mediaId);
        reviews.assignAll(list);
      },
      errorMsg: "Error: While Getting Reviews",
      loading: false,
    );
  }

  Future<void> addReview() async {
    await super.runAction(
      action: () async {
        final newReview = MediaReview(
          mediaId: mediaId,
          content: content.value,
          date: date,
        );
        await _reviewRepository.addReview(newReview);
        await fetchReviews();
      },
      errorMsg: "Error: While Creating Review",
      successMsg: "Succesfully Created Review",
    );
  }

  Future<void> updateReview() async {
    await super.runAction(
      action: () async {
        final updatedReview = MediaReview(
          id: reviewId ?? (throw ("Review Id is NULL")),
          mediaId: mediaId,
          content: content.value,
          date: date,
        );
        await _reviewRepository.updateReview(updatedReview);
        await fetchReviews();
      },
      errorMsg: "Error: While Updating Review",
      successMsg: "Succesfully Updated Review",
    );
  }

  Future<void> deleteReview(int id) async {
    await super.runAction(
      action: () async {
        await _reviewRepository.deleteReview(id);
        await fetchReviews();
      },
      errorMsg: "Error: While Deleting Review",
      successMsg: "Succesfully Deleted Review",
    );
  }
}

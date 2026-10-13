import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/base/base_controller.dart';
import 'package:flutter_general_reviewer/models/media_review.dart';
import 'package:flutter_general_reviewer/repository/review_repo.dart';
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
    setLoading(true);
    mediaId = Get.arguments as int;
    fetchReviews();
    setLoading(false);
  }

  void initReviewForm(MediaReview? review) {
    if (review != null) {
      reviewId = review.id;
      content.value = review.content;
      date = review.date;
    } else {
      reviewId = null;
      content.value = '';
      date = DateTime.now();
    }
  }

  Future<void> fetchReviews() async {
    try {
      final list = await _reviewRepository.getReviews(mediaId);
      reviews.assignAll(list);
    } catch (e) {
      debugPrint("Error: While Getting Reviews");
    }
  }

  Future<void> addReview() async {
    try {
      setLoading(true);
      final newReview = MediaReview(
        mediaId: mediaId,
        content: content.value,
        date: date,
      );
      await _reviewRepository.addReview(newReview);
      await fetchReviews();
      showSuccessSnackBar(message: "Succesfully Created Review");
    } catch (e) {
      showErrorSnackBar(
        message: "Error: While Creating Reviews \nERROR:${e.toString()}",
      );
    } finally {
      setLoading(false);
    }
  }

  Future<void> updateReview() async {
    try {
      setLoading(true);
      final updatedReview = MediaReview(
        id: reviewId ?? (throw ("Review Id is NULL")),
        mediaId: mediaId,
        content: content.value,
        date: date,
      );
      await _reviewRepository.updateReview(updatedReview);
      await fetchReviews();
      showSuccessSnackBar(message: "Succesfully Updated Review");
    } catch (e) {
      showErrorSnackBar(
        message: "Error: While Updating Reviews \nERROR:${e.toString()}",
      );
    } finally {
      setLoading(false);
    }
  }

  Future<void> deleteReview(int id) async {
    try {
      setLoading(true);
      await _reviewRepository.deleteReview(id);
      await fetchReviews();
      showSuccessSnackBar(message: "Succesfully Deleted Review");
    } catch (e) {
      showErrorSnackBar(
        message: "Error: While Deleting Reviews \nERROR:${e.toString()}",
      );
    } finally {
      setLoading(false);
    }
  }
}

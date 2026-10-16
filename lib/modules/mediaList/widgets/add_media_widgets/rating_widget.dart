import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/mediaList/media_controller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

Obx ratingWidget(MediaController controller) {
  return Obx(
    () => RatingBar.builder(
      initialRating: controller.rating.value.toDouble(),
      itemCount: 6,
      itemBuilder: (context, index) {
        switch (index) {
          case 0:
            return const Icon(
              Icons.sentiment_very_dissatisfied,
              color: Colors.red,
            );
          case 1:
            return const Icon(
              Icons.sentiment_dissatisfied,
              color: Colors.redAccent,
            );
          case 2:
            return const Icon(Icons.sentiment_neutral, color: Colors.amber);
          case 3:
            return const Icon(
              Icons.sentiment_satisfied,
              color: Colors.lightGreen,
            );
          case 4:
            return const Icon(
              Icons.sentiment_very_satisfied,
              color: Colors.green,
            );
          case 5:
            return const Icon(Icons.star, color: Colors.blue);
          default:
            return const Icon(Icons.error);
        }
      },
      onRatingUpdate: (value) => controller.rating.value = value.toInt(),
    ),
  );
}
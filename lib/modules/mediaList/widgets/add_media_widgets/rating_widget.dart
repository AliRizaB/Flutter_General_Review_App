import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/mediaList/media_controller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

final List<Icon> _ratingIcons = [
  Icon(Icons.sentiment_very_dissatisfied, color: Colors.red),
  Icon(Icons.sentiment_dissatisfied, color: Colors.redAccent),
  Icon(Icons.sentiment_neutral, color: Colors.amber),
  Icon(Icons.sentiment_satisfied, color: Colors.lightGreen),
  Icon(Icons.sentiment_very_satisfied, color: Colors.green),
  Icon(Icons.star, color: Colors.blue),
];

Widget ratingWidget(MediaController controller) {
  return Obx(
    () => RatingBar.builder(
      initialRating: controller.rating.value.toDouble(),
      itemCount: _ratingIcons.length,
      itemBuilder: (context, index) {
        if (index >= 0 && index < _ratingIcons.length) {
          return _ratingIcons[index];
        }
        return const Icon(Icons.error);
      },
      onRatingUpdate: (value) => controller.rating.value = value.toInt(),
    ),
  );
}

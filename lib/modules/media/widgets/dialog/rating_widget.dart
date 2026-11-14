import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/modules/media/media_controller.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

final List<Icon> _ratingIcons = [
  Icon(Icons.sentiment_very_dissatisfied, color: Colors.red),
  Icon(Icons.sentiment_dissatisfied, color: Colors.redAccent),
  Icon(Icons.sentiment_neutral, color: Colors.amber),
  Icon(Icons.sentiment_satisfied, color: Colors.lightGreen),
  Icon(Icons.sentiment_very_satisfied, color: Colors.green),
  Icon(Icons.star, color: Colors.blue),
];

class RatingWidget extends GetView<MediaController> {
  const RatingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => FittedBox(
        fit: BoxFit.scaleDown,
        child: RatingBar.builder(
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
      ),
    );
  }
}

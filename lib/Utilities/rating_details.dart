import 'package:flutter/material.dart';

class RatingDetails {
  final IconData icon;
  final Color color;
  final String label;

  RatingDetails(this.icon, this.color, this.label);
}

RatingDetails getRatingDetails(int rating) {
  switch (rating) {
    case 1:
      return RatingDetails(
        Icons.sentiment_very_dissatisfied,
        Colors.red,
        'Terrible',
      );
    case 2:
      return RatingDetails(
        Icons.sentiment_dissatisfied,
        Colors.redAccent,
        'Poor',
      );
    case 3:
      return RatingDetails(
        Icons.sentiment_neutral,
        Colors.amber.shade700,
        'Average',
      );
    case 4:
      return RatingDetails(
        Icons.sentiment_satisfied,
        Colors.lightGreen.shade700,
        'Good',
      );
    case 5:
      return RatingDetails(
        Icons.sentiment_very_satisfied,
        Colors.green,
        'Very Good',
      );
    case 6:
      return RatingDetails(Icons.star_rounded, Colors.blue, 'Excellent');
    default:
      return RatingDetails(Icons.help_outline, Colors.grey, 'Unrated');
  }
}

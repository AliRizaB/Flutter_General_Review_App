import '../services/database_service.dart';

class AppReview {
  final int id;
  final int mediaId;

  final String content;
  final DateTime date;

  AppReview({
    required this.id,
    required this.mediaId,
    required this.content,
    required this.date,
  });

  factory AppReview.fromMap(Map<String, dynamic> map) {
    return AppReview(
      id: map[DBConstants.reviewId] as int,
      mediaId: map[DBConstants.reviewMediaId] as int,
      content: map[DBConstants.reviewContent] as String,
      date: DateTime.parse(map[DBConstants.reviewDate] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id > 0) DBConstants.reviewId: id,
      DBConstants.reviewMediaId: mediaId,
      DBConstants.reviewContent: content,
      DBConstants.reviewDate: date.toIso8601String(),
    };
  }
}

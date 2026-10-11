import '../services/database_service.dart';

class MediaReview {
  final int id;
  final int mediaId;

  final String content;
  final DateTime date;

  MediaReview({
    required this.id,
    required this.mediaId,
    required this.content,
    required this.date,
  });

  factory MediaReview.fromMap(Map<String, dynamic> map) {
    return MediaReview(
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

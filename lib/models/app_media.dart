import '../services/database_service.dart';

class AppMedia {
  final int id;
  final int? statusId;
  final int categoryId;
  final String name;
  final int rating;
  final String? description;
  final String? imagePath;
  

  AppMedia({
    required this.id,
    required this.name,
    this.description,
    required this.rating,
    this.imagePath,
    this.statusId,
    required this.categoryId,
  });

  factory AppMedia.fromMap(Map<String, dynamic> map) {
    return AppMedia(
      id: map[DBConstants.mediaId] as int,
      statusId: map[DBConstants.mediaStatusId] as int?,
      categoryId: map[DBConstants.mediaCategoryId] as int,
      name: map[DBConstants.mediaName] as String,
      description: map[DBConstants.mediaDescription] as String?,
      rating: map[DBConstants.mediaRating] as int,
      imagePath: map[DBConstants.mediaImage] as String?,
      
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id > 0) DBConstants.mediaId: id,
      DBConstants.mediaCategoryId: categoryId,
      DBConstants.mediaStatusId: statusId,
      DBConstants.mediaName: name,
      DBConstants.mediaRating: rating,
      DBConstants.mediaDescription: description,
      DBConstants.mediaImage: imagePath,
    };
  }
}

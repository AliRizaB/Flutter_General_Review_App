import 'package:flutter_general_reviewer/services/database_service.dart';

class AppCategory {
  final int id;
  final String name;
  final String color;

  AppCategory({required this.id, required this.name, required this.color});

  factory AppCategory.fromMap(Map<String, dynamic> map) {
    return AppCategory(
      id: map[DBConstants.categoryId] as int,
      name: map[DBConstants.categoryName] as String,
      color: map[DBConstants.categoryColor] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id > 0) DBConstants.categoryId: id,
      DBConstants.categoryName: name,
      DBConstants.categoryColor: color,
    };
  }
}

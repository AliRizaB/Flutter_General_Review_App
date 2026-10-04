import 'package:flutter/material.dart';
import 'package:flutter_general_reviewer/services/database_service.dart';

class AppCategory {
  final int? id;
  final String name;
  final String color;

  AppCategory({this.id, required this.name, required this.color});

  factory AppCategory.fromMap(Map<String, dynamic> map) {
    return AppCategory(
      id: map[DBConstants.categoryId] as int,
      name: map[DBConstants.categoryName] as String,
      color: map[DBConstants.categoryColor] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) DBConstants.categoryId: id,
      DBConstants.categoryName: name,
      DBConstants.categoryColor: color,
    };
  }

  Color get getColor {
    String hexString = color.replaceAll('#', '').replaceAll('0x', '').trim();
    if (hexString.length == 6) {
      hexString = 'FF$hexString';
    }
    return Color(int.parse(hexString, radix: 16));
  }

  Color get contrastTextColor {
    return getColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }
}

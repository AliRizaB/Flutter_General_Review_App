import 'package:flutter/material.dart';

import '../services/database_service.dart';

class MediaStatus {
  final int? id;
  final String name;
  final String color;

  MediaStatus({this.id, required this.name, required this.color});

  factory MediaStatus.fromMap(Map<String, dynamic> map) {
    return MediaStatus(
      id: map[DBConstants.statusId] as int,
      name: map[DBConstants.statusName] as String,
      color: map[DBConstants.statusColor] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != 0) DBConstants.statusId: id,
      DBConstants.statusName: name,
      DBConstants.statusColor: color,
    };
  }

  Color get getColor {
    String hexString = color.replaceAll('#', '').replaceAll('0x', '').trim();
    if (hexString.length == 6) {
      hexString = 'FF$hexString';
    }
    return Color(int.parse(hexString, radix: 16));
  }
}

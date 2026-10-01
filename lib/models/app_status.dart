import '../services/database_service.dart';

class AppStatus {
  final int id;
  final String name;
  final String color;

  AppStatus({required this.id, required this.name, required this.color});

  factory AppStatus.fromMap(Map<String, dynamic> map) {
    return AppStatus(
      id: map[DBConstants.statusId] as int,
      name: map[DBConstants.statusName] as String,
      color: map[DBConstants.statusColor] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id > 0) DBConstants.statusId: id,
      DBConstants.statusName: name,
      DBConstants.statusColor: color,
    };
  }
}

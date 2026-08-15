import 'package:plant_scanner_app/plant_simulation/domain/entity/schedule_task_entity.dart';

class ScheduleTaskModel extends ScheduleTaskEntity {
  const ScheduleTaskModel({
    required super.id,
    required super.dayAfterPlanting,
    required super.taskTitle,
    required super.scheduledDate,
    required super.taskType,
    required super.description,
  });

  factory ScheduleTaskModel.fromJson(Map<String, dynamic> json) {
    return ScheduleTaskModel(
      id: json["_id"] ?? "",
      dayAfterPlanting: json["days_after_planting"] ?? "",
      taskTitle: json["title"] ?? "",
      scheduledDate: json['scheduled_date'] ?? "",
      description: json["description"] ?? "",
      taskType: json["task_type"] ?? "",
    );
  }

  factory ScheduleTaskModel.fromEntity(ScheduleTaskEntity entity) {
    return ScheduleTaskModel(
      id: entity.id,
      dayAfterPlanting: entity.dayAfterPlanting,
      taskTitle: entity.taskTitle,
      scheduledDate: entity.scheduledDate,
      taskType: entity.taskType,
      description: entity.description,
    );
  }

  /// Stable 32-bit notification id derived from Mongo `_id` hex when possible.
  int get notificationId {
    if (id.isNotEmpty) {
      final hex = id.replaceAll(RegExp(r'[^0-9a-fA-F]'), '');
      if (hex.length >= 8) {
        try {
          final parsed = int.parse(hex.substring(hex.length - 8), radix: 16);
          final normalized = parsed & 0x7FFFFFFF;
          return normalized == 0 ? 1 : normalized;
        } catch (_) {
          // Fall through to Object.hash
        }
      }
    }

    final hashed =
        Object.hash(id, scheduledDate, taskTitle, taskType) & 0x7FFFFFFF;
    return hashed == 0 ? 1 : hashed;
  }
}

import 'package:flutter/foundation.dart';
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

  // ✅ DB ID ကို notification ID အဖြစ် သုံးပါ
  int get notificationId {
    int id = this.id.hashCode.abs();
    if (id < 0) id = -id;
    if (id == 0) id = 1;
    if (id > 2147483647) id = id % 2147483647 + 1;
    return id;
  }
}

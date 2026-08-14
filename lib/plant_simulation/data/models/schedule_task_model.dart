import 'package:plant_scanner_app/plant_simulation/domain/entity/schedule_task_entity.dart';

class ScheduleTaskModel extends ScheduleTaskEntity {
  const ScheduleTaskModel({
    required super.id,
    required super.dayAfterPlanting,
    required super.taskTitle,
    required super.taskType,
    required super.description,
  });

  factory ScheduleTaskModel.fromJson(Map<String, dynamic> json) {
    return ScheduleTaskModel(
      id: json["_id"] ?? "",
      dayAfterPlanting: json["days_after_planting"] ?? "",
      taskTitle: json["title"] ?? "",
      description: json["description"] ?? "",
      taskType: json["task_type"] ?? "",
    );
  }
}

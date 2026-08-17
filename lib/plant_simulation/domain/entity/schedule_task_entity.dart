import 'package:equatable/equatable.dart';

class ScheduleTaskEntity extends Equatable {
  final String id;
  final String farmName;
  final String dayAfterPlanting;
  final String taskTitle;
  final String scheduledDate;
  final String description;
  final String taskType;

  const ScheduleTaskEntity({
    required this.id,
    required this.farmName,
    required this.dayAfterPlanting,
    required this.taskTitle,
    required this.scheduledDate,
    required this.description,
    required this.taskType,
  });

  @override
  List<Object?> get props => [
    id,
    farmName,
    dayAfterPlanting,
    taskTitle,
    scheduledDate,
    description,
    taskType,
  ];
}

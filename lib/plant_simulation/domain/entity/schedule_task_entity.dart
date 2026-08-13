import 'package:equatable/equatable.dart';

class ScheduleTaskEntity extends Equatable {
  final String id;
  final num dayAfterPlanting;
  final String taskTitle;
  final String description;
  final String taskType;

  const ScheduleTaskEntity({
    required this.id,
    required this.dayAfterPlanting,
    required this.taskTitle,
    required this.description,
    required this.taskType,
  });

  @override
  List<Object?> get props => [
    id,
    dayAfterPlanting,
    taskTitle,
    description,
    taskType,
  ];
}

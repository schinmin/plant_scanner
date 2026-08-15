// lib/core/notifications/schedule_tasks_notification.dart

import 'package:flutter/foundation.dart';
import 'package:plant_scanner_app/core/notifications/local_notification_service.dart';
import 'package:plant_scanner_app/plant_simulation/data/models/schedule_task_model.dart';

class ScheduleTaskNotificationService {
  final NotificationService _notificationService;

  ScheduleTaskNotificationService({NotificationService? notificationService})
    : _notificationService = notificationService ?? NotificationService();

  /// Returns how many notifications were successfully scheduled.
  Future<int> scheduleTasksNotifications(List<ScheduleTaskModel> tasks) async {
    if (tasks.isEmpty) {
      debugPrint('No schedule tasks found');
      return 0;
    }

    debugPrint('Scheduling ${tasks.length} tasks...');
    var scheduledCount = 0;

    for (final task in tasks) {
      final taskModel = ScheduleTaskModel.fromEntity(task);
      final ok = await _scheduleSingleTaskNotification(task: taskModel);
      if (ok) scheduledCount++;
    }

    debugPrint('Scheduled $scheduledCount / ${tasks.length} tasks');
    return scheduledCount;
  }

  Future<bool> _scheduleSingleTaskNotification({
    required ScheduleTaskModel task,
  }) async {
    try {
      final notificationTime = _resolveNotificationTime(task.scheduledDate);

      if (!notificationTime.isAfter(DateTime.now())) {
        debugPrint('Skipping a past schedule task');
        return false;
      }

      final taskData = _getTaskTypeData(task.taskType);
      final title = '${taskData['icon']} ${task.taskTitle}';
      final body =
          '''
📋 ${task.description}
📅 ${_formatDate(notificationTime)}
🏷️ ${taskData['label']}
🌾 ${task.taskTitle}
''';

      final scheduled = await _notificationService.scheduleTaskNotification(
        id: task.notificationId,
        title: title,
        body: body,
        scheduledDate: notificationTime,
        payloadData: task.id.isNotEmpty
            ? task.id
            : task.notificationId.toString(),
      );

      if (scheduled) {
        debugPrint('Scheduled a task notification');
      }
      return scheduled;
    } catch (_) {
      debugPrint('Could not schedule a task notification');
      return false;
    }
  }

  /// Uses the API datetime as-is. If only a date (midnight) is sent, default
  /// to 09:00 local so farm reminders fire in the morning.
  DateTime _resolveNotificationTime(String scheduledDateRaw) {
    final parsed = DateTime.parse(scheduledDateRaw).toLocal();

    final isDateOnly =
        parsed.hour == 0 &&
        parsed.minute == 0 &&
        parsed.second == 0 &&
        parsed.millisecond == 0;

    if (isDateOnly) {
      return DateTime(parsed.year, parsed.month, parsed.day, 9, 0);
    }

    return parsed;
  }

  Map<String, String> _getTaskTypeData(String taskType) {
    const map = {
      'Land Preparation': {'icon': '🚜', 'label': 'မြေပြင်ခြင်း'},
      'Fertilization': {'icon': '🌱', 'label': 'မြေဩဇာကျွေးခြင်း'},
      'Irrigation': {'icon': '💧', 'label': 'ရေသွင်းခြင်း'},
      'Pest Control': {'icon': '🐛', 'label': 'ပိုးမွှားကာကွယ်ခြင်း'},
      'Weeding': {'icon': '🌿', 'label': 'ပေါင်းရှင်းခြင်း'},
      'Harvesting': {'icon': '🌾', 'label': 'ရိတ်သိမ်းခြင်း'},
      'GENERAL': {'icon': '📋', 'label': 'အထွေထွေ'},
    };
    return map[taskType] ?? map['GENERAL']!;
  }

  String _formatDate(DateTime date) {
    const months = [
      'ဇန်နဝါရီ',
      'ဖေဖော်ဝါရီ',
      'မတ်',
      'ဧပြီ',
      'မေ',
      'ဇွန်',
      'ဇူလိုင်',
      'သြဂုတ်',
      'စက်တင်ဘာ',
      'အောက်တိုဘာ',
      'နိုဝင်ဘာ',
      'ဒီဇင်ဘာ',
    ];

    var hour = date.hour;
    final amPm = hour >= 12 ? 'နေ့လည်' : 'မနက်';
    if (hour > 12) hour -= 12;
    if (hour == 0) hour = 12;

    return '${date.day} ${months[date.month - 1]} ${date.year}, '
        '$amPm $hour:${date.minute.toString().padLeft(2, '0')}';
  }

  Future<void> cancelAllNotifications() async {
    await _notificationService.cancelAllNotifications();
    debugPrint('All notifications cancelled');
  }
}

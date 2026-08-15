// lib/plant_simulation/services/schedule_task_notification_service.dart

import 'package:flutter/widgets.dart';
import 'package:plant_scanner_app/core/notifications/local_notification_service.dart';
import 'package:plant_scanner_app/plant_simulation/data/models/schedule_task_model.dart';

class ScheduleTaskNotificationService {
  final NotificationService _notificationService;

  ScheduleTaskNotificationService({NotificationService? notificationService})
    : _notificationService = notificationService ?? NotificationService();

  /// ✅ Simulation ရဲ့ schedule_tasks တွေကို notification schedule လုပ်ခြင်း
  Future<void> scheduleTasksNotifications(List<ScheduleTaskModel> tasks) async {
    if (tasks.isEmpty) {
      print('📭 No schedule tasks found');
      return;
    }

    print('📅 Scheduling ${tasks.length} tasks...');

    for (final task in tasks) {
      final taskModel = ScheduleTaskModel.fromEntity(task);
      await _scheduleSingleTaskNotification(task: taskModel);
    }

    print('✅ All tasks scheduled successfully!');
  }

  /// Task တစ်ခုချင်းစီအတွက် notification schedule လုပ်ခြင်း
  Future<void> _scheduleSingleTaskNotification({
    required ScheduleTaskModel task,
  }) async {
    try {
      final now = DateTime.now();

      final scheduledDate = DateTime.parse(task.scheduledDate);

      bool shouldSkip = false;

      // ဒီနေ့ဖြစ်ရင် hour/minute ပဲ စစ်မယ်
      if (scheduledDate.year == now.year &&
          scheduledDate.month == now.month &&
          scheduledDate.day == now.day) {
        final currentMinutes = now.hour * 60 + now.minute;
        final scheduledMinutes = scheduledDate.hour * 60 + scheduledDate.minute;

        if (scheduledMinutes <= currentMinutes) {
          shouldSkip = true;
        }
      }

      if (shouldSkip) {
        debugPrint('⏭️ Skipping past task: ${task.taskTitle}');
        return;
      }

      final date = DateTime.parse(task.scheduledDate);

      // ၂. ရက်လွန်နေပြီဆိုရင် ကျော်ပါ

      // ၃. မနက် ၉ နာရီ သတ်မှတ်ပါ
      final DateTime notificationTime = DateTime(
        date.year,
        date.month,
        date.day,
        18, // မနက် ၉ နာရီ
        30,
        0,
      );

      // ၄. Task type ပေါ်မူတည်ပြီး icon နဲ့ label ရွေးပါ
      final taskData = _getTaskTypeData(task.taskType);

      // ၅. Notification content ပြင်ဆင်ပါ
      final String title = '${taskData['icon']} ${task.taskTitle}';
      final String body =
          '''
📋 ${task.description}
📅 ${_formatDate(notificationTime)}
🏷️ ${taskData['label']}
🌾 ${task.taskTitle}
''';

      // ၆. Payload data ပြင်ဆင်ပါ
      final payload = task.notificationId.toString();

      // ၇. Notification schedule လုပ်ပါ
      await _notificationService.scheduleTaskNotification(
        id: task.notificationId,
        title: title,
        body: body,
        scheduledDate: notificationTime,
        payloadData: payload,
      );

      print('✅ Scheduled: ${task.taskTitle} (ID: ${task.notificationId})');
    } catch (e) {
      print('❌ Failed: ${task.taskTitle} - $e');
    }
  }

  /// Task type ပေါ်မူတည်ပြီး data ပြန်ပေးခြင်း
  Map<String, String> _getTaskTypeData(String taskType) {
    final Map<String, Map<String, String>> map = {
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

  /// ရက်စွဲကို မြန်မာလိုဖော်မတ်ပြုလုပ်ခြင်း
  String _formatDate(DateTime date) {
    final months = [
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

    // နာရီကို ၁၂ နာရီပုံစံပြောင်းပါ
    int hour = date.hour;
    String amPm = hour >= 12 ? 'နေ့လည်' : 'မနက်';
    if (hour > 12) hour -= 12;
    if (hour == 0) hour = 12;

    return '${date.day} ${months[date.month - 1]} ${date.year}, $amPm $hour:${date.minute.toString().padLeft(2, '0')}';
  }

  /// ✅ Notification အားလုံးကို ပယ်ဖျက်ခြင်း
  Future<void> cancelAllNotifications() async {
    await _notificationService.cancelAllNotifications();
    print('🗑️ All notifications cancelled');
  }
}

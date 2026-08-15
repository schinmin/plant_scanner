// Manual debug helper — do not call from production main().
import 'package:flutter/foundation.dart';
import 'package:plant_scanner_app/core/notifications/local_notification_service.dart';
import 'package:plant_scanner_app/core/notifications/schedule_tasks_notification.dart';
import 'package:plant_scanner_app/plant_simulation/data/models/schedule_task_model.dart';

class QuickTest {
  static Future<void> runQuickTest() async {
    debugPrint('Starting notification Quick Test...');

    final notificationService = NotificationService();
    await notificationService.initNotification();

    final service = ScheduleTaskNotificationService(
      notificationService: notificationService,
    );

    final pending = await notificationService.getPendingNotifications();
    debugPrint('Existing pending notifications: ${pending.length}');

    final testTask = ScheduleTaskModel(
      id: 'quick_test_${DateTime.now().millisecondsSinceEpoch}',
      taskTitle: 'Quick Test Notification',
      description: 'This is a quick test notification',
      taskType: 'GENERAL',
      // Non-midnight time so scheduler does not rewrite to 09:00.
      scheduledDate: DateTime.now()
          .add(const Duration(seconds: 15))
          .toIso8601String(),
      dayAfterPlanting: '0',
    );

    debugPrint('Scheduling test task for ~15 seconds later...');
    final count = await service.scheduleTasksNotifications([testTask]);
    debugPrint('Test scheduled count: $count');

    await Future<void>.delayed(const Duration(seconds: 2));
    final updatedPending = await notificationService.getPendingNotifications();
    debugPrint(
      'Pending notifications after scheduling: ${updatedPending.length}',
    );

    for (final notification in updatedPending) {
      debugPrint('ID: ${notification.id}, Title: ${notification.title}');
    }
  }
}

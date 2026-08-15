// lib/test_quick.dart

import 'package:plant_scanner_app/core/notifications/local_notification_service.dart';
import 'package:plant_scanner_app/core/notifications/schedule_tasks_notification.dart';
import 'package:plant_scanner_app/plant_simulation/data/models/schedule_task_model.dart';

class QuickTest {
  static Future<void> runQuickTest() async {
    print('🧪 Starting Quick Test...');

    final notificationService = NotificationService();
    final service = ScheduleTaskNotificationService();

    // ✅ ၁. Pending Notifications ကို စစ်ဆေးပါ
    final pending = await notificationService.getPendingNotifications();
    print('📋 Existing pending notifications: ${pending.length}');

    // ✅ ၂. Test Task: 15 seconds later
    final testTask = ScheduleTaskModel(
      id: 'quick_test_${DateTime.now().millisecondsSinceEpoch}',
      taskTitle: '🧪 Quick Test Notification',
      description: 'This is a quick test notification',
      taskType: 'GENERAL',
      scheduledDate: DateTime.now()
          .add(Duration(seconds: 15))
          .toIso8601String(),
      dayAfterPlanting: "0",
    );

    print('📅 Scheduling test task for 15 seconds later...');
    await service.scheduleTasksNotifications([testTask]);

    print('✅ Test notification scheduled!');
    print('⏰ Please wait 15 seconds for notification to appear...');

    // ✅ ၃. Pending Notifications ကို ပြန်စစ်ဆေးပါ
    await Future.delayed(Duration(seconds: 2));
    final updatedPending = await notificationService.getPendingNotifications();
    print(
      '📋 Pending notifications after scheduling: ${updatedPending.length}',
    );

    if (updatedPending.isNotEmpty) {
      for (var notification in updatedPending) {
        print('   ✅ ID: ${notification.id}, Title: ${notification.title}');
      }
    }
  }
}

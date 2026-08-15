import 'package:flutter/foundation.dart';
import 'package:plant_scanner_app/core/notifications/local_notification_service.dart';

class QuickTest {
  static const int _notificationId = 900001;
  static const Duration defaultDelay = Duration(seconds: 10);

  /// Schedules one debug notification relative to the current time.
  ///
  /// The stable ID replaces an older app-start test instead of accumulating
  /// pending notifications after every launch.
  static Future<bool> runOnAppStart({
    NotificationService? notificationService,
    Duration delay = defaultDelay,
  }) async {
    if (delay <= Duration.zero) {
      debugPrint(
        'App-start notification test skipped: delay must be positive.',
      );
      return false;
    }

    final service = notificationService ?? NotificationService();

    try {
      await service.initNotification();

      final scheduledAt = DateTime.now().add(delay);
      final scheduled = await service.scheduleTaskNotification(
        id: _notificationId,
        title: 'Notification Test',
        body: 'The app-start notification test is working.',
        scheduledDate: scheduledAt,
        payloadData: 'app_start_notification_test',
      );

      debugPrint(
        'App-start notification test ${scheduled ? 'scheduled' : 'skipped'} '
        'for $scheduledAt.',
      );

      return scheduled;
    } catch (error, stackTrace) {
      debugPrint('App-start notification test failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      return false;
    }
  }
}

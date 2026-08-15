// lib/core/notifications/local_notification_service.dart

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:typed_data';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// ✅ Notification ကို Initialize လုပ်ခြင်း
  Future<void> initNotification() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // ✅ ၁. Android 13+ Permission တောင်းပါ
    await _requestNotificationPermission();

    // ✅ ၂. Notification Channel ကို Create လုပ်ပါ
    await _createNotificationChannels();
  }

  /// ✅ Notification Permission တောင်းခြင်း
  Future<void> _requestNotificationPermission() async {
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      final bool? result = await androidPlugin.requestNotificationsPermission();
      print('📱 Notification Permission: $result');
    }
  }

  /// ✅ Notification Channel ကို Create လုပ်ခြင်း
  Future<void> _createNotificationChannels() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'simulation_tasks_channel',
      'စိုက်ပျိုးရေး အကြောင်းကြားချက်များ',
      description: 'စိုက်ပျိုးရေး လုပ်ငန်းစဉ်များအတွက် အကြောင်းကြားချက်များ',
      importance: Importance.max,
      enableVibration: true,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
    );

    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(channel);
      print('✅ Notification channel created: simulation_tasks_channel');
    }
  }

  /// ✅ Notification Tap Handler
  void _onNotificationTap(NotificationResponse response) {
    final String? payload = response.payload;
    print('📬 Notification tapped! Payload: $payload');

    // TODO: Navigate to appropriate screen
    // Get.to(() => TaskDetailScreen(taskId: payload));
  }

  /// ✅ Exact Alarm Permission စစ်ဆေးခြင်း
  Future<bool> checkExactAlarmPermission() async {
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    final result =
        await androidPlugin?.canScheduleExactNotifications() ?? false;
    print('🔔 Exact alarm permission: $result');
    return result;
  }

  /// ✅ Task notification schedule လုပ်ခြင်း
  Future<bool> scheduleTaskNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payloadData,
  }) async {
    // ၁. ရက်လွန်နေပြီဆိုရင် မလုပ်ပါ
    if (scheduledDate.isBefore(DateTime.now())) {
      print('⏭️ Skipping past notification: $title');
      return false;
    }

    // ၂. ID ကို သေချာစစ်ဆေးပါ
    int finalId = id.abs();
    if (finalId < 0) finalId = -finalId;
    if (finalId == 0) finalId = 1;
    if (finalId > 2147483647) finalId = finalId % 2147483647 + 1;

    // ✅ ၃. ID ရှိပြီးသားလား စစ်ဆေးပါ
    final bool isAlreadyScheduled = await _isNotificationIdExists(finalId);

    if (isAlreadyScheduled) {
      print('⚠️ Notification ID $finalId already exists! Skipping...');
      return false;
    }

    // ✅ ၄. Exact Alarm Permission စစ်ဆေးပါ
    final bool hasExactAlarmPermission = await checkExactAlarmPermission();
    if (!hasExactAlarmPermission) {
      print('⚠️ No exact alarm permission! Using inexact schedule...');
    }

    // ✅ ၅. Notification Details
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'simulation_tasks_channel',
          'စိုက်ပျိုးရေး အကြောင်းကြားချက်များ',
          channelDescription:
              'စိုက်ပျိုးရေး လုပ်ငန်းစဉ်များအတွက် အကြောင်းကြားချက်များ',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          //color: Colors.green.value,
          enableVibration: true,
          vibrationPattern: Int64List.fromList([0, 500, 200, 500]),
          styleInformation: BigTextStyleInformation(body),
          autoCancel: false,
          ongoing: false,
        );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        sound: 'notification.wav',
      ),
    );

    final tz.TZDateTime tzScheduledDate = tz.TZDateTime.from(
      scheduledDate,
      tz.local,
    );

    print('📅 Scheduling notification at: $tzScheduledDate');
    print('📱 ID: $finalId, Title: $title');

    // ✅ ၆. Notification ကို Schedule လုပ်ပါ
    await _notificationsPlugin.zonedSchedule(
      id: finalId,
      scheduledDate: tzScheduledDate,
      notificationDetails: notificationDetails,
      androidScheduleMode: hasExactAlarmPermission
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle,
      title: title,
      body: body,
      payload: payloadData ?? 'task_$finalId',
    );

    print('✅ Scheduled notification ID: $finalId');
    return true;
  }

  /// ✅ Notification ID ရှိပြီးသားလား စစ်ဆေးခြင်း
  Future<bool> _isNotificationIdExists(int id) async {
    try {
      final pending = await _notificationsPlugin.pendingNotificationRequests();
      return pending.any((notification) => notification.id == id);
    } catch (e) {
      print('Error checking notification existence: $e');
      return false;
    }
  }

  /// ✅ ID အလိုက် Notification ရှိမရှိ စစ်ဆေးခြင်း
  Future<bool> isNotificationScheduled(int id) async {
    return await _isNotificationIdExists(id);
  }

  /// ✅ Pending Notifications အားလုံးကို ရယူခြင်း
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      return await _notificationsPlugin.pendingNotificationRequests();
    } catch (e) {
      print('Error getting pending notifications: $e');
      return [];
    }
  }

  /// ✅ Notification ကို ပယ်ဖျက်ခြင်း
  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id: id);
    print('🗑️ Cancelled notification ID: $id');
  }

  /// ✅ အားလုံးကို ပယ်ဖျက်ခြင်း
  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
    print('🗑️ All notifications cancelled');
  }
}

// lib/core/notifications/local_notification_service.dart

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

enum ExactAlarmPromptResult { granted, continueInexact }

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// Initialize plugin, timezone, permissions, and channels once.
  Future<void> initNotification() async {
    if (_initialized) return;

    await _configureLocalTimeZone();

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

    await _requestNotificationPermission();
    await _requestExactAlarmPermission();
    await _createNotificationChannels();

    _initialized = true;
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    try {
      final timeZoneInfo = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneInfo.identifier));
      debugPrint('Timezone set to: ${timeZoneInfo.identifier}');
    } catch (e) {
      // Fallback keeps scheduling working if location lookup fails.
      tz.setLocalLocation(tz.getLocation('Asia/Yangon'));
      debugPrint('Timezone fallback Asia/Yangon ($e)');
    }
  }

  Future<void> _requestNotificationPermission() async {
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      final bool? result = await androidPlugin.requestNotificationsPermission();
      debugPrint('Notification Permission: $result');
    }
  }

  Future<void> _requestExactAlarmPermission() async {
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin == null) return;

    final canExact =
        await androidPlugin.canScheduleExactNotifications() ?? false;
    if (!canExact) {
      final granted = await androidPlugin.requestExactAlarmsPermission();
      debugPrint('Exact alarm permission requested: $granted');
    }
  }

  Future<void> _createNotificationChannels() async {
    // No custom raw sound — missing res/raw/notification breaks the channel.
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'simulation_tasks_channel',
      'စိုက်ပျိုးရေး အကြောင်းကြားချက်များ',
      description: 'စိုက်ပျိုးရေး လုပ်ငန်းစဉ်များအတွက် အကြောင်းကြားချက်များ',
      importance: Importance.max,
      enableVibration: true,
      playSound: true,
    );

    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(channel);
      debugPrint('Notification channel created: simulation_tasks_channel');
    }
  }

  void _onNotificationTap(NotificationResponse response) {
    final String? payload = response.payload;
    debugPrint('Notification tapped! Payload: $payload');
  }

  /// Show an immediate test notification (useful on every app open).
  Future<void> showTestNotification() async {
    if (!_initialized) {
      await initNotification();
    }

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'simulation_tasks_channel',
          'စိုက်ပျိုးရေး အကြောင်းကြားချက်များ',
          channelDescription:
              'စိုက်ပျိုးရေး လုပ်ငန်းစဉ်များအတွက် အကြောင်းကြားချက်များ',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          enableVibration: true,
          playSound: true,
        );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _notificationsPlugin.show(
      id: 99999,
      title: 'စိုက်ပျိုးရေး သတိပေးချက်',
      body: 'သင်၏ စပါးစိုက်ခင်းသည် ယနေ့ ပိုးသတ်ဆေးဖြန်းရန် ဖြစ်ပါသည်။',
      notificationDetails: notificationDetails,
      payload: 'test_on_open',
    );

    debugPrint('Test notification shown on app open');
  }

  Future<bool> checkExactAlarmPermission() async {
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    final result =
        await androidPlugin?.canScheduleExactNotifications() ?? false;
    debugPrint('Exact alarm permission: $result');
    return result;
  }

  /// Opens system exact-alarm settings for this app (Android 12+).
  Future<bool> requestExactAlarmPermission() async {
    final androidPlugin = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin == null) return true;

    final granted = await androidPlugin.requestExactAlarmsPermission();
    debugPrint('Exact alarm permission result: $granted');
    return granted ?? await checkExactAlarmPermission();
  }

  /// Returns true if exact alarms are allowed, or user dismissed and we
  /// should continue with inexact scheduling.
  Future<ExactAlarmPromptResult> ensureExactAlarmPermissionWithPrompt({
    required Future<bool?> Function() showRationaleDialog,
  }) async {
    if (await checkExactAlarmPermission()) {
      return ExactAlarmPromptResult.granted;
    }

    final shouldOpenSettings = await showRationaleDialog();
    if (shouldOpenSettings != true) {
      return ExactAlarmPromptResult.continueInexact;
    }

    final granted = await requestExactAlarmPermission();
    return granted
        ? ExactAlarmPromptResult.granted
        : ExactAlarmPromptResult.continueInexact;
  }

  /// Normalize to a positive 32-bit notification id.
  int normalizeNotificationId(int id) {
    var finalId = id & 0x7FFFFFFF;
    if (finalId == 0) finalId = 1;
    return finalId;
  }

  /// Schedule (or replace) a task notification.
  Future<bool> scheduleTaskNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payloadData,
  }) async {
    if (!_initialized) {
      await initNotification();
    }

    if (!scheduledDate.isAfter(DateTime.now())) {
      debugPrint('Skipping past notification: $title');
      return false;
    }

    final finalId = normalizeNotificationId(id);

    // Replace existing schedule for this ID instead of silently skipping.
    await _notificationsPlugin.cancel(id: finalId);

    final hasExactAlarmPermission = await checkExactAlarmPermission();
    if (!hasExactAlarmPermission) {
      debugPrint('No exact alarm permission — using inexact schedule');
    }

    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'simulation_tasks_channel',
          'စိုက်ပျိုးရေး အကြောင်းကြားချက်များ',
          channelDescription:
              'စိုက်ပျိုးရေး လုပ်ငန်းစဉ်များအတွက် အကြောင်းကြားချက်များ',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          enableVibration: true,
          vibrationPattern: Int64List.fromList([0, 500, 200, 500]),
          styleInformation: BigTextStyleInformation(body),
          autoCancel: true,
          ongoing: false,
        );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    final tz.TZDateTime tzScheduledDate = tz.TZDateTime.from(
      scheduledDate,
      tz.local,
    );
    final Map<String, dynamic> payloadMap = {
      'task_id': id.toString(),
      'title': title,
      'scheduled_date': scheduledDate.toIso8601String(), // ✅ Date ကို သိမ်းပါ
      'payload': payloadData ?? 'task_$id',
    };

    final String payload = jsonEncode(payloadMap);

    debugPrint('Scheduling notification at: $tzScheduledDate');
    debugPrint('ID: $finalId, Title: $title');

    await _notificationsPlugin.zonedSchedule(
      id: finalId,
      scheduledDate: tzScheduledDate,
      notificationDetails: notificationDetails,
      androidScheduleMode: hasExactAlarmPermission
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle,
      title: title,
      body: body,
      payload: payload,
    );

    debugPrint('Scheduled notification ID: $finalId');
    return true;
  }

  Future<bool> _isNotificationIdExists(int id) async {
    try {
      final pending = await _notificationsPlugin.pendingNotificationRequests();
      return pending.any((notification) => notification.id == id);
    } catch (e) {
      debugPrint('Error checking notification existence: $e');
      return false;
    }
  }

  Future<bool> isNotificationScheduled(int id) async {
    return _isNotificationIdExists(normalizeNotificationId(id));
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      return await _notificationsPlugin.pendingNotificationRequests();
    } catch (e) {
      debugPrint('Error getting pending notifications: $e');
      return [];
    }
  }

  Future<void> cancelNotification(int id) async {
    final finalId = normalizeNotificationId(id);
    await _notificationsPlugin.cancel(id: finalId);
    debugPrint('Cancelled notification ID: $finalId');
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
    debugPrint('All notifications cancelled');
  }
}

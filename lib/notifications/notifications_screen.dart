// lib/plant_simulation/presentation/screens/notification_list_screen.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import '../../core/notifications/local_notification_service.dart';
import '../../core/notifications/schedule_tasks_notification.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  final NotificationService _notificationService = NotificationService();
  late ScheduleTaskNotificationService _scheduleService;

  List<PendingNotificationRequest> _pendingNotifications = [];
  bool _isLoading = true;
  bool _hasExactAlarmPermission = false;

  @override
  void initState() {
    super.initState();
    _scheduleService = ScheduleTaskNotificationService(
      notificationService: _notificationService,
    );
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      _pendingNotifications = await _notificationService
          .getPendingNotifications();
      _hasExactAlarmPermission = await _notificationService
          .checkExactAlarmPermission();
    } catch (e) {
      debugPrint('Error loading notifications: $e');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Refresh Button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Refresh',
          ),
          // Cancel All Button
          IconButton(
            icon: const Icon(Icons.notifications_off),
            onPressed: _showCancelAllDialog,
            tooltip: 'Cancel All',
          ),
        ],
      ),
      body: Column(
        children: [
          // ✅ Permission Status Bar
          _buildPermissionStatusBar(),

          // ✅ Main Content
          Expanded(
            child: _isLoading
                ? _buildLoadingState()
                : _pendingNotifications.isEmpty
                ? _buildEmptyState()
                : _buildNotificationList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTestNotificationDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Notification'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
    );
  }

  // ==========================================
  // Permission Status Bar
  // ==========================================
  Widget _buildPermissionStatusBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: _hasExactAlarmPermission
          ? Colors.green.shade50
          : Colors.orange.shade50,
      child: Row(
        children: [
          Icon(
            _hasExactAlarmPermission ? Icons.check_circle : Icons.warning,
            color: _hasExactAlarmPermission ? Colors.green : Colors.orange,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _hasExactAlarmPermission
                  ? '✅ တိကျသော နှိုးစက်/သတိပေးချက် ခွင့်ပြုချက် ရရှိထားပါသည်။ သတိပေးချက်များ ကွက်တိအချိန်၌ ပေါ်လာမည် ဖြစ်သည်။'
                  : '⚠️ တိကျသော နှိုးစက်/သတိပေးချက် ခွင့်ပြုချက်ကို ပိတ်ထားပါသည်။ သတိပေးချက်များ လာရောက်ရန် ကြန့်ကြာနိုင်ပါသည်။',
              style: TextStyle(
                fontSize: 13,
                color: _hasExactAlarmPermission
                    ? Colors.green.shade800
                    : Colors.orange.shade800,
              ),
            ),
          ),
          if (!_hasExactAlarmPermission)
            TextButton(
              onPressed: _requestExactAlarmPermission,
              child: const Text('Request'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.orange.shade700,
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
        ],
      ),
    );
  }

  // ==========================================
  // Loading State
  // ==========================================
  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.green),
          SizedBox(height: 16),
          Text(
            'Loading notifications...',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Empty State
  // ==========================================
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'စီစဉ်ထားသော အကြောင်းကြားချက်များ မရှိပါ',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Simulation ဖန်တီးပြီး "Notification ပေးပါ" ကိုနှိပ်ပါ',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadData,
              icon: const Icon(Icons.refresh),
              label: const Text('Refresh'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // Notification List
  // ==========================================
  Widget _buildNotificationList() {
    return RefreshIndicator(
      onRefresh: _loadData,
      color: Colors.green,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _pendingNotifications.length,
        itemBuilder: (context, index) {
          final reverseNotifications = _pendingNotifications.reversed.toList();
          final notification = _pendingNotifications[index];
          return _buildNotificationCard(notification);
        },
      ),
    );
  }

  // ==========================================
  // Notification Card (No scheduledDate - use payload or show generic info)
  // ==========================================
  Widget _buildNotificationCard(PendingNotificationRequest notification) {
    // ✅ PendingNotificationRequest မှာ scheduledDate မပါပါ
    // ဒါကြောင့် payload ကနေ အချက်အလက်တွေကို ဆွဲယူပါ သို့မဟုတ် generic info ပြပါ

    // Payload ကနေ task_id ကို ဆွဲထုတ်ပါ

    //final Map<String, dynamic> data = jsonEncode(notification.p);
    String taskId = notification.payload ?? 'N/A';

    // Safely decode or assign an empty map if payload is null
    final Map<String, dynamic> decodedData = notification.payload != null
        ? jsonDecode(notification.payload ?? "")
        : {};

    // Now decodedData is guaranteed to be assigned on all execution paths
    final DateTime scheduledTaskDate = decodedData.containsKey('scheduled_date')
        ? DateTime.parse(decodedData['scheduled_date'])
        : DateTime.now();

    String scheduledDateText = "";
    // Payload က JSON string ဖြစ်နိုင်ရင် parse လုပ်ပါ
    try {
      if (notification.payload != null &&
          notification.payload!.startsWith('{')) {
        // JSON ဖြစ်ရင် parse လုပ်ပါ
        final Map<String, dynamic> data = Map.from(
          notification.payload!.split(',').fold({}, (prev, element) {
            final parts = element.split(':');
            if (parts.length == 2) {
              prev[parts[0].trim().replaceAll('"', '')] = parts[1]
                  .trim()
                  .replaceAll('}', '')
                  .replaceAll('"', '');
            }
            return prev;
          }),
        );
        taskId = data['task_id'] ?? data['simulation_id'] ?? taskId;
        scheduledDateText = data['scheduled_date'] ?? 'Unknown';
      }
    } catch (e) {
      // JSON မဟုတ်ရင် payload ကိုပဲ သုံးပါ
      taskId = notification.payload ?? 'N/A';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _showNotificationDetail(notification);
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat('MMM dd, yyyy').format(scheduledTaskDate)),
                // Header Row
                Row(
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.notifications_active,
                        color: Colors.green,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Title

                    // Payload Badge
                    if (notification.payload != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Has Data',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ),

                    const SizedBox(width: 100),

                    TextButton.icon(
                      onPressed: () {
                        _cancelSingleNotification(notification.id);
                      },
                      icon: const Icon(Icons.close, size: 16),
                      label: const Text('Cancel'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red.shade700,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: const Size(0, 32),
                      ),
                    ),
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title ?? 'No Title',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Text(
                    //   'ID: ${notification.id}',
                    //   style: TextStyle(
                    //     fontSize: 12,
                    //     color: Colors.grey.shade500,
                    //   ),
                    // ),
                  ],
                ),

                const SizedBox(height: 8),

                // Body
                if (notification.body != null)
                  Text(
                    notification.body!,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                const SizedBox(height: 8),

                // Payload Info
                // Row(
                //   children: [
                //     Icon(
                //       Icons.info_outline,
                //       size: 14,
                //       color: Colors.grey.shade500,
                //     ),
                //     const SizedBox(width: 4),
                //     Expanded(
                //       child: Text(
                //         'Task: $taskId',
                //         style: TextStyle(
                //           fontSize: 12,
                //           color: Colors.grey.shade500,
                //         ),
                //         maxLines: 1,
                //         overflow: TextOverflow.ellipsis,
                //       ),
                //     ),

                //     // Cancel Button

                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // Dialogs & Actions
  // ==========================================

  /// Show Notification Detail Dialog
  void _showNotificationDetail(PendingNotificationRequest notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.notifications, color: Colors.green.shade700),
            const SizedBox(width: 8),
            const Text('Notification Details'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('ID', notification.id.toString()),
            _buildDetailRow('Title', notification.title ?? 'N/A'),
            _buildDetailRow('Body', notification.body ?? 'N/A'),
            _buildDetailRow('Payload', notification.payload ?? 'N/A'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _cancelSingleNotification(notification.id);
            },
            icon: const Icon(Icons.delete, size: 16),
            label: const Text('Cancel'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Cancel Single Notification
  Future<void> _cancelSingleNotification(int id) async {
    try {
      await _notificationService.cancelNotification(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Notification ID $id cancelled'),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
      _loadData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Failed to cancel: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Cancel All Notifications Dialog
  void _showCancelAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('အားလုံး ဖျက်မည်'),
        content: Text(
          'စီစဉ်ထားသော အကြောင်းကြားချက် ${_pendingNotifications.length} ခုလုံးကို ဖျက်မည်။ ဆက်လက်လုပ်ဆောင်မည်လား?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('မလုပ်တော့ပါ'),
          ),
          TextButton.icon(
            onPressed: () async {
              Navigator.pop(context);
              await _notificationService.cancelAllNotifications();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🗑️ All notifications cancelled'),
                  backgroundColor: Colors.orange,
                ),
              );
              _loadData();
            },
            icon: const Icon(Icons.delete_forever, size: 16),
            label: const Text('အားလုံးဖျက်မည်'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  /// Request Exact Alarm Permission
  Future<void> _requestExactAlarmPermission() async {
    final granted = await _notificationService.requestExactAlarmPermission();
    setState(() {
      _hasExactAlarmPermission = granted;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          granted
              ? '✅ Exact alarm permission granted'
              : '⚠️ Exact alarm permission denied',
        ),
        backgroundColor: granted ? Colors.green : Colors.orange,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Add Test Notification Dialog
  void _showAddTestNotificationDialog() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController bodyController = TextEditingController();
    DateTime selectedDate = DateTime.now().add(const Duration(minutes: 1));

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Notification အသစ်ထည့်ရန်'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: bodyController,
                    decoration: const InputDecoration(
                      labelText: 'Body',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    title: const Text('Scheduled Date'),
                    subtitle: Text(
                      DateFormat('dd/MM/yyyy HH:mm').format(selectedDate),
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 30)),
                      );
                      if (picked != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(selectedDate),
                        );
                        if (time != null) {
                          setDialogState(() {
                            selectedDate = DateTime(
                              picked.year,
                              picked.month,
                              picked.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await _scheduleTestNotification(
                    title: titleController.text.isNotEmpty
                        ? titleController.text
                        : '🧪 Test Notification',
                    body: bodyController.text.isNotEmpty
                        ? bodyController.text
                        : 'This is a test notification',
                    scheduledDate: selectedDate,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Schedule'),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Schedule Test Notification
  Future<void> _scheduleTestNotification({
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch % 100000;
      final success = await _notificationService.scheduleTaskNotification(
        id: id,
        title: title,
        body: body,
        scheduledDate: scheduledDate,
        payloadData: 'test_notification_$id',
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '✅ Test notification scheduled for ${DateFormat('HH:mm').format(scheduledDate)}',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
        _loadData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Failed to schedule test notification'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error: $e'), backgroundColor: Colors.red),
      );
    }
  }
}

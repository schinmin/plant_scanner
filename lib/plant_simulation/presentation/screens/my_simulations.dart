// lib/plant_simulation/presentation/screens/my_simulations_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:plant_scanner_app/core/notifications/local_notification_service.dart';
import 'package:plant_scanner_app/core/notifications/schedule_tasks_notification.dart';
import 'package:plant_scanner_app/plant_simulation/data/models/schedule_task_model.dart';
import 'package:plant_scanner_app/plant_simulation/presentation/bloc/bloc/simulation_bloc.dart';
import 'package:plant_scanner_app/plant_simulation/domain/entity/farm_simulation_entity.dart';
import 'package:plant_scanner_app/plant_simulation/presentation/screens/simulation_detail_screen.dart';
import 'package:plant_scanner_app/plant_simulation/presentation/screens/simulation_screen.dart';

class MySimulationsScreen extends StatefulWidget {
  const MySimulationsScreen({super.key});

  @override
  State<MySimulationsScreen> createState() => _MySimulationsScreenState();
}

class _MySimulationsScreenState extends State<MySimulationsScreen> {
  late final ScheduleTaskNotificationService _notificationService;
  late final NotificationService _localNotificationService;

  @override
  void initState() {
    super.initState();
    _localNotificationService = NotificationService();
    _notificationService = ScheduleTaskNotificationService(
      notificationService: _localNotificationService,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<SimulationBloc>().add(GetSimulationEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SimulationBloc, SimulationState>(
        listenWhen: (previous, current) => current is SimulationsListFailure,
        listener: (context, state) {
          if (state is SimulationsListFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message.message}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        buildWhen: (previous, current) =>
            current is SimulationsListLoading ||
            current is SimulationsListLoaded ||
            current is SimulationsListFailure ||
            current is SimulationInitial,
        builder: (context, state) {
          if (state is SimulationsListLoading || state is SimulationInitial) {
            return _buildLoadingState();
          }
          if (state is SimulationsListFailure) {
            return _buildErrorState(state.message.message, context);
          }
          if (state is SimulationsListLoaded) {
            if (state.farmSimulations.isEmpty) {
              return _buildEmptyState(context);
            }
            return _buildSimulationList(state.farmSimulations, context);
          }

          return _buildLoadingState();
        },
      ),
    );
  }

  // ==========================================
  // Loading, Error, Empty States
  // ==========================================

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.green),
          SizedBox(height: 16),
          Text(
            'Loading your simulations...',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String errorMessage, BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<SimulationBloc>().add(GetSimulationEvent());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.agriculture,
                size: 80,
                color: Colors.green.shade700,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Simulations Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Start your first farm simulation today!\nCreate a new simulation to get started.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SimulationScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Create Simulation'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
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
  // Simulation List
  // ==========================================

  Widget _buildSimulationList(
    List<FarmSimulationEntity> simulations,
    BuildContext context,
  ) {
    // schedule_tasks ရှိတဲ့ simulations တွေကိုပဲ ရွေးပါ
    final simulationsWithTasks = simulations
        .where((sim) => sim.scheduleTasks.isNotEmpty)
        .toList();

    return RefreshIndicator(
      onRefresh: () async {
        context.read<SimulationBloc>().add(GetSimulationEvent());
      },
      color: Colors.green,
      child: Column(
        children: [
          // ✅ "အားလုံး Notification ပေးပါ" Button
          if (simulationsWithTasks.isNotEmpty)
            _buildScheduleAllButton(simulationsWithTasks, context),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: simulations.length,
              itemBuilder: (context, index) {
                final simulation = simulations[index];
                return _buildSimulationCard(simulation, context);
              },
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // Simulation Card with Notification Button
  // ==========================================

  Widget _buildSimulationCard(
    FarmSimulationEntity simulation,
    BuildContext context,
  ) {
    final hasTasks = simulation.scheduleTasks.isNotEmpty;
    final isNarrow = MediaQuery.sizeOf(context).width < 380;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    SimulationSuccessScreen(simulation: simulation),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    hasTasks
                        ? ElevatedButton.icon(
                            onPressed: () {
                              _scheduleNotificationsForSimulation(simulation);
                            },
                            icon: const Icon(
                              Icons.notifications_active,
                              size: 18,
                            ),
                            label: const Text('Notification ပေးပါ'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.notifications_off,
                                  size: 16,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'No Tasks',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                    _buildInfoChip(
                      icon: Icons.calendar_today,
                      label: DateFormat(
                        'y-MM-dd',
                      ).format(simulation.createdAt ?? DateTime.now()),
                    ),
                  ],
                ),

                // Header with farm name and status
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.agriculture,
                        color: Colors.green.shade700,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            simulation.farmName ?? "",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            simulation.riceType ?? "",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusBadge(simulation),
                  ],
                ),
                const SizedBox(height: 16),

                // Details row
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildInfoChip(
                      icon: Icons.landscape,
                      label: simulation.soilType ?? '',
                    ),
                    _buildInfoChip(
                      icon: Icons.square_foot,
                      label:
                          '${simulation.farmArea?.toStringAsFixed(1) ?? '0'} acres',
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Divider
                Divider(color: Colors.grey.shade200),
                const SizedBox(height: 8),

                // Financial summary
                Wrap(
                  spacing: 12,
                  runSpacing: 8,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    _buildFinancialInfo(
                      'ကုန်ကျစရိတ်',
                      simulation.totalEstimatedCost?.toString() ?? 'N/A',
                      Colors.blue,
                    ),
                    _buildFinancialInfo(
                      'ဝင်ငွေ',
                      simulation.estimatedIncome?.toString() ?? 'N/A',
                      Colors.green,
                    ),
                    _buildFinancialInfo(
                      'ROI',
                      simulation.roiPercentage != null
                          ? '${simulation.roiPercentage!.toStringAsFixed(1)}%'
                          : 'N/A',
                      _isProfitable(simulation) ? Colors.green : Colors.red,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Action buttons
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: isNarrow
                      ? WrapAlignment.start
                      : WrapAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        _showDeleteConfirmation(context, simulation);
                      },
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: const Text('Delete'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red.shade700,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SimulationSuccessScreen(
                              simulation: simulation,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.visibility, size: 18),
                      label: const Text('View Details'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // Notification Functions
  // ==========================================

  /// ✅ Simulation တစ်ခုအတွက် Notification schedule လုပ်ခြင်း
  Future<void> _scheduleNotificationsForSimulation(
    FarmSimulationEntity simulation,
  ) async {
    try {
      await _promptExactAlarmIfNeeded();

      if (!mounted) return;
      ScaffoldMessenger.of(this.context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 12),
              Text('Scheduling notifications...'),
            ],
          ),
          duration: Duration(seconds: 2),
        ),
      );

      final scheduleTasks = simulation.scheduleTasks
          .map((task) => ScheduleTaskModel.fromEntity(task))
          .toList();

      final scheduledCount = await _notificationService
          .scheduleTasksNotifications(scheduleTasks);

      if (!mounted) return;
      final allSkipped = scheduledCount == 0 && scheduleTasks.isNotEmpty;
      ScaffoldMessenger.of(this.context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                allSkipped ? Icons.info_outline : Icons.check_circle,
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  allSkipped
                      ? 'No upcoming tasks to schedule (all past or invalid).'
                      : '✅ Scheduled $scheduledCount notification(s).',
                ),
              ),
            ],
          ),
          backgroundColor: allSkipped ? Colors.orange : Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(this.context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(child: Text('❌ Failed: ${e.toString()}')),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
      debugPrint('Error scheduling notifications: $e');
    }
  }

  Future<void> _promptExactAlarmIfNeeded() async {
    if (!mounted) return;
    await _localNotificationService.ensureExactAlarmPermissionWithPrompt(
      showRationaleDialog: () {
        return showDialog<bool>(
          context: this.context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Exact alarm permission'),
            content: const Text(
              'Farm schedule reminders work best with exact alarms. '
              'Open settings to allow this app to schedule exact alarms?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Later'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('Open settings'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _scheduleAllNotifications(
    List<FarmSimulationEntity> simulations,
  ) async {
    int successCount = 0;
    int failCount = 0;
    var totalNotifications = 0;

    await _promptExactAlarmIfNeeded();
    if (!mounted) return;

    ScaffoldMessenger.of(this.context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 12),
            Text('Scheduling all notifications...'),
          ],
        ),
        duration: Duration(seconds: 3),
      ),
    );

    for (final simulation in simulations) {
      try {
        final models = simulation.scheduleTasks
            .map((task) => ScheduleTaskModel.fromEntity(task))
            .toList();
        totalNotifications += await _notificationService
            .scheduleTasksNotifications(models);
        successCount++;
      } catch (e) {
        failCount++;
        debugPrint('Failed for ${simulation.farmName}: $e');
      }
    }

    if (!mounted) return;
    ScaffoldMessenger.of(this.context).showSnackBar(
      SnackBar(
        content: Text(
          '✅ $successCount farms ($totalNotifications notifications), '
          '$failCount failed',
        ),
        backgroundColor: failCount == 0 ? Colors.green : Colors.orange,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Widget _buildScheduleAllButton(
    List<FarmSimulationEntity> simulationsWithTasks,
    BuildContext context,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            _scheduleAllNotifications(simulationsWithTasks);
          },
          icon: const Icon(Icons.notifications_active),
          label: Text(
            'အားလုံး Notification ပေးပါ (${simulationsWithTasks.length})',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange.shade700,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // Helper Widgets
  // ==========================================

  bool _isProfitable(FarmSimulationEntity simulation) {
    final income = simulation.estimatedIncome;
    final cost = simulation.totalEstimatedCost;
    if (income != null && cost != null) {
      return income >= cost;
    }
    final profit = simulation.estimatedProfit;
    if (profit != null) return profit >= 0;
    final roi = simulation.roiPercentage;
    if (roi != null) return roi >= 0;
    return false;
  }

  Widget _buildStatusBadge(FarmSimulationEntity simulation) {
    final isProfitable = _isProfitable(simulation);
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isProfitable ? Colors.green.shade100 : Colors.red.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isProfitable ? Icons.trending_up : Icons.trending_down,
              size: 16,
              color: isProfitable ? Colors.green.shade700 : Colors.red.shade700,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                isProfitable
                    ? 'မြတ်နိုင်သည့်စိုက်ခင်း'
                    : 'အရှုံးပေါ် နိုင်သည့်စိုက်ခင်း',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isProfitable
                      ? Colors.green.shade700
                      : Colors.red.shade700,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade700),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialInfo(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    FarmSimulationEntity simulation,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Simulation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to delete this simulation?',
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 8),
            Text(
              'Farm: ${simulation.farmName}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Plant: ${simulation.riceType}',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // context.read<SimulationBloc>().add(
              //   DeleteSimulationEvent(id: simulation.id),
              // );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

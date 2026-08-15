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
  FarmSimulationEntity? _simulationPendingDeletion;

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
      backgroundColor: const Color(0xFFF4F7F2),
      body: BlocConsumer<SimulationBloc, SimulationState>(
        listenWhen: (previous, current) =>
            current is SimulationsListFailure ||
            current is SimulationDeleteSuccess ||
            current is SimulationDeleteFailure,
        listener: (context, state) {
          if (state is SimulationsListFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message.message}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          } else if (state is SimulationDeleteSuccess) {
            _handleDeleteSuccess(state.id);
          } else if (state is SimulationDeleteFailure) {
            _handleDeleteFailure(state);
          }
        },
        buildWhen: (previous, current) =>
            current is SimulationsListLoading ||
            current is SimulationsListLoaded ||
            current is SimulationsListFailure ||
            current is SimulationDeleteInProgress ||
            current is SimulationDeleteSuccess ||
            current is SimulationDeleteFailure ||
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
          if (state is SimulationDeleteInProgress) {
            return _buildSimulationList(
              state.farmSimulations,
              context,
              deletingSimulationId: state.id,
            );
          }
          if (state is SimulationDeleteSuccess) {
            if (state.farmSimulations.isEmpty) {
              return _buildEmptyState(context);
            }
            return _buildSimulationList(state.farmSimulations, context);
          }
          if (state is SimulationDeleteFailure) {
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
    BuildContext context, {
    String? deletingSimulationId,
  }) {
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
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
              itemCount: simulations.length,
              itemBuilder: (context, index) {
                final simulation = simulations[index];
                return _buildSimulationCard(
                  simulation,
                  context,
                  deletingSimulationId: deletingSimulationId,
                );
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
    BuildContext context, {
    String? deletingSimulationId,
  }) {
    final hasTasks = simulation.scheduleTasks.isNotEmpty;

    void openDetails() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SimulationSuccessScreen(simulation: simulation),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2EAE0)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B5E20).withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: openDetails,
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF43A047), Color(0xFF1B5E20)],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.agriculture_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _displayValue(simulation.farmName, 'Unnamed farm'),
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF17211A),
                              letterSpacing: -0.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Icon(
                                Icons.grass_rounded,
                                size: 15,
                                color: Color(0xFF66806B),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  _displayValue(
                                    simulation.riceType,
                                    'Crop not specified',
                                  ),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF66806B),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F6EF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildStatusBadge(simulation),
                    _buildInfoChip(
                      icon: Icons.calendar_month_rounded,
                      label: DateFormat(
                        'dd MMM yyyy',
                      ).format(simulation.createdAt ?? DateTime.now()),
                    ),
                    if (simulation.season?.trim().isNotEmpty == true)
                      _buildInfoChip(
                        icon: Icons.wb_sunny_outlined,
                        label: simulation.season!,
                      ),
                    _buildInfoChip(
                      icon: Icons.landscape_outlined,
                      label: _displayValue(simulation.soilType, 'Unknown soil'),
                    ),
                    _buildInfoChip(
                      icon: Icons.square_foot_rounded,
                      label:
                          '${simulation.farmArea?.toStringAsFixed(1) ?? '0'} acres',
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F8F5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildFinancialInfo(
                          icon: Icons.payments_outlined,
                          label: 'ကုန်ကျစရိတ်',
                          value: _formatAmount(simulation.totalEstimatedCost),
                          color: const Color(0xFF546E7A),
                        ),
                      ),
                      _buildMetricDivider(),
                      Expanded(
                        child: _buildFinancialInfo(
                          icon: Icons.account_balance_wallet_outlined,
                          label: 'ဝင်ငွေ',
                          value: _formatAmount(simulation.estimatedIncome),
                          color: const Color(0xFF2E7D32),
                        ),
                      ),
                      _buildMetricDivider(),
                      Expanded(
                        child: _buildFinancialInfo(
                          icon: Icons.trending_up_rounded,
                          label: 'ROI',
                          value: simulation.roiPercentage != null
                              ? '${simulation.roiPercentage!.toStringAsFixed(1)}%'
                              : 'N/A',
                          color: _isProfitable(simulation)
                              ? const Color(0xFF2E7D32)
                              : const Color(0xFFC62828),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.end,
                  children: [
                    if (hasTasks)
                      OutlinedButton.icon(
                        onPressed: () {
                          _scheduleNotificationsForSimulation(simulation);
                        },
                        icon: const Icon(
                          Icons.notifications_active_outlined,
                          size: 18,
                        ),
                        label: Text(
                          'Notification (${simulation.scheduleTasks.length})',
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF2E7D32),
                          side: const BorderSide(color: Color(0xFFB8D4B8)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      )
                    else
                      _buildInfoChip(
                        icon: Icons.notifications_off_outlined,
                        label: 'No tasks',
                      ),
                    IconButton(
                      onPressed: deletingSimulationId == simulation.id
                          ? null
                          : () {
                              _showDeleteConfirmation(context, simulation);
                            },
                      tooltip: 'Delete simulation',
                      icon: deletingSimulationId == simulation.id
                          ? const SizedBox.square(
                              dimension: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.delete_outline_rounded, size: 20),
                      color: const Color(0xFFC62828),
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0xFFFFEBEE),
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: openDetails,
                      icon: const Icon(Icons.visibility_outlined, size: 18),
                      label: const Text('View Details'),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF2E7D32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
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
      ScaffoldMessenger.of(context).showSnackBar(
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
      ScaffoldMessenger.of(context).showSnackBar(
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
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 12),
              const Expanded(child: Text('❌ Failed to schedule notifications')),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
      debugPrint('Could not schedule simulation notifications');
    }
  }

  Future<void> _promptExactAlarmIfNeeded() async {
    if (!mounted) return;
    await _localNotificationService.ensureExactAlarmPermissionWithPrompt(
      showRationaleDialog: () {
        return showDialog<bool>(
          context: context,
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

    ScaffoldMessenger.of(context).showSnackBar(
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
      } catch (_) {
        failCount++;
        debugPrint('Could not schedule notifications for a simulation');
      }
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
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
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: () {
            _scheduleAllNotifications(simulationsWithTasks);
          },
          icon: const Icon(Icons.notifications_active_outlined),
          label: Text(
            'အားလုံး Notification ပေးပါ (${simulationsWithTasks.length})',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF2E7D32),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
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
    final foreground = isProfitable
        ? const Color(0xFF1B5E20)
        : const Color(0xFFB71C1C);
    final background = isProfitable
        ? const Color(0xFFE8F5E9)
        : const Color(0xFFFFEBEE);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isProfitable
                ? Icons.trending_up_rounded
                : Icons.trending_down_rounded,
            size: 15,
            color: foreground,
          ),
          const SizedBox(width: 5),
          Text(
            isProfitable ? 'အမြတ်ရနိုင်' : 'အရှုံးဖြစ်နိုင်',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: foreground,
            ),
          ),
        ],
      ),
    );
  }

  String _displayValue(String? value, String fallback) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? fallback : trimmed;
  }

  String _formatAmount(num? value) {
    if (value == null) return 'N/A';
    return NumberFormat.compact().format(value);
  }

  Widget _buildMetricDivider() {
    return Container(
      width: 1,
      height: 42,
      margin: const EdgeInsets.symmetric(horizontal: 7),
      color: const Color(0xFFDDE5DA),
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F6EF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF55745B)),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4D6251),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialInfo({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  color: Color(0xFF718075),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: color,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  void _showDeleteConfirmation(
    BuildContext context,
    FarmSimulationEntity simulation,
  ) {
    final simulationId = simulation.id?.trim();
    if (simulationId == null || simulationId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This simulation cannot be deleted.')),
      );
      return;
    }
    final simulationBloc = context.read<SimulationBloc>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
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
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _simulationPendingDeletion = simulation;
              simulationBloc.add(DeleteSimulationEvent(id: simulationId));
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleDeleteSuccess(String simulationId) async {
    final deletedSimulation = _simulationPendingDeletion;
    if (deletedSimulation?.id == simulationId) {
      _simulationPendingDeletion = null;
    }

    if (deletedSimulation?.id == simulationId) {
      for (final task in deletedSimulation!.scheduleTasks) {
        final taskModel = ScheduleTaskModel.fromEntity(task);
        try {
          await _localNotificationService.cancelNotification(
            taskModel.notificationId,
          );
        } catch (_) {
          debugPrint('Could not cancel a deleted simulation reminder');
        }
      }
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Simulation deleted successfully.'),
        backgroundColor: Colors.green,
      ),
    );
    context.read<SimulationBloc>().add(GetSimulationEvent());
  }

  void _handleDeleteFailure(SimulationDeleteFailure state) {
    if (!mounted) return;
    if (_simulationPendingDeletion?.id == state.id) {
      _simulationPendingDeletion = null;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(state.message.message),
        backgroundColor: Colors.red,
      ),
    );
  }
}

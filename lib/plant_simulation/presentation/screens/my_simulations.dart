import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:plant_scanner_app/plant_simulation/presentation/bloc/bloc/simulation_bloc.dart';
import 'package:plant_scanner_app/plant_simulation/domain/entity/farm_simulation_entity.dart';
import 'package:plant_scanner_app/plant_simulation/presentation/screens/simulation_detail_screen.dart';

class MySimulationsScreen extends StatelessWidget {
  const MySimulationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     'My Simulations',
      //     style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      //   ),
      //   backgroundColor: Colors.green.shade700,
      //   elevation: 0,
      //   centerTitle: true,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back, color: Colors.white),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.refresh, color: Colors.white),
      //       onPressed: () {
      //         context.read<SimulationBloc>().add(GetSimulationEvent());
      //         ScaffoldMessenger.of(context).showSnackBar(
      //           const SnackBar(
      //             content: Text('Refreshing simulations...'),
      //             duration: Duration(seconds: 1),
      //           ),
      //         );
      //       },
      //     ),
      //   ],
      // ),
      body: BlocConsumer<SimulationBloc, SimulationState>(
        listener: (context, state) {
          if (state is SimulationLoadedError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message.message}'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          } else if (state is SimulationLoading) {
            const Center(child: CircularProgressIndicator());
            // Refresh the list after deletion
            // context.read<SimulationBloc>().add(GetSimulationsEvent());
          }
        },
        builder: (context, state) {
          if (state is SimulationLoading) {
            return _buildLoadingState();
          } else if (state is SimulationLoadedError) {
            return _buildErrorState(state.message.message, context);
          } else if (state is GetSimulationData) {
            if (state.farmSimulations.isEmpty) {
              return _buildEmptyState(context);
            }
            return _buildSimulationList(state.farmSimulations, context);
          } else if (state is SimulationInitial) {
            // Trigger initial load
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<SimulationBloc>().add(GetSimulationEvent());
            });
            return _buildLoadingState();
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("မင်းရဲ့ စိုက်ခင်း များမရှိသေးပါ။"),
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
          );
        },
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     Navigator.pushAndRemoveUntil(
      //       context,
      //       MaterialPageRoute(builder: (context) => SimulationScreen()),
      //       (route) => false,
      //     );
      //   },
      //   backgroundColor: Colors.green.shade700,
      //   icon: const Icon(Icons.add, color: Colors.white),
      //   label: const Text(
      //     'New Simulation',
      //     style: TextStyle(color: Colors.white),
      //   ),
      // ),
    );
  }

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
                Navigator.pushNamed(context, '/create-simulation');
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

  Widget _buildSimulationList(
    List<FarmSimulationEntity> simulations,
    BuildContext context,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<SimulationBloc>().add(GetSimulationEvent());
      },
      color: Colors.green,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: simulations.length,
        itemBuilder: (context, index) {
          final simulation = simulations[index];
          return _buildSimulationCard(simulation, context);
        },
      ),
    );
  }

  Widget _buildSimulationCard(
    FarmSimulationEntity simulation,
    BuildContext context,
  ) {
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
            // Navigate to simulation detail
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
                        Icons.three_k,
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
                Row(
                  children: [
                    _buildInfoChip(
                      icon: Icons.landscape,
                      label: simulation.soilType ?? "",
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      icon: Icons.square_foot,
                      label:
                          '${simulation.farmArea?.toStringAsFixed(1) ?? '0'} acres',
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      icon: Icons.calendar_today,
                      label: DateFormat(
                        'y-MM-dd',
                      ).format(simulation.createdAt ?? DateTime.now()),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Divider
                Divider(color: Colors.grey.shade200),
                const SizedBox(height: 8),

                // Financial summary
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      simulation.estimatedProfit! <
                              simulation.totalEstimatedCost!
                          ? Colors.green
                          : Colors.red,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
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
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SimulationSuccessScreen(simulation: simulation),
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

  Widget _buildStatusBadge(FarmSimulationEntity simulation) {
    final isProfitable =
        simulation.estimatedIncome! > simulation.totalEstimatedCost!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
          Text(
            isProfitable
                ? 'မြတ်နိုင်သည့်စိုက်ခင်း'
                : 'အရှုံးပေါ် နိုင်သည့်စိုက်ခင်း',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isProfitable ? Colors.green.shade700 : Colors.red.shade700,
            ),
          ),
        ],
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

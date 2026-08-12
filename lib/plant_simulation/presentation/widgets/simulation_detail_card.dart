import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:plant_scanner_app/plant_simulation/domain/entity/farm_simulation_entity.dart';

class SimulationDetailCard extends StatelessWidget {
  final FarmSimulationEntity simulation;

  const SimulationDetailCard({super.key, required this.simulation});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📋 လယ်ယာအချက်အလက်များ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            Icons.agriculture,
            'လယ်ယာအမည်',
            simulation.farmName ?? "",
          ),
          _buildDivider(),
          _buildDetailRow(
            Icons.grass,
            'စပါးအမျိုးအစား',
            simulation.riceType ?? "",
          ),
          _buildDivider(),
          _buildDetailRow(
            Icons.landscape,
            'မြေအမျိုးအစား',
            simulation.soilType ?? "",
          ),
          _buildDivider(),
          _buildDetailRow(
            Icons.wb_sunny,
            'စိုက်ပျိုးရာသီ',
            simulation.season ?? "",
          ),
          _buildDivider(),
          _buildDetailRow(Icons.crop, 'စိုက်ဧက', '${simulation.farmArea} ဧက'),
          _buildDivider(),
          _buildDetailRow(
            Icons.calendar_today,
            'စိုက်ပျိုးရက်',
            simulation.createdAt ?? "",
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.green.shade700),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(height: 12, color: Colors.grey.shade200);
  }
}

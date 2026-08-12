import 'package:flutter/material.dart';
import 'package:plant_scanner_app/plant_simulation/domain/entity/farm_simulation_entity.dart';

class SummaryCard extends StatelessWidget {
  final FarmSimulationEntity simulation;

  const SummaryCard({super.key, required this.simulation});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade700, Colors.green.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📊 ခန့်မှန်းချက် အကျဉ်းချုပ်',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildSummaryItem(
                '🌾 အထွက်နှုန်း',
                '${simulation.expectedYieldPerAcre} တင်း/ဧက',
                'စုစုပေါင်း ${simulation.totalProduction} တင်း',
              ),
              const SizedBox(width: 12),
              _buildSummaryItem(
                '💰 ကုန်ကျစရိတ်',
                '${_formatCurrency(simulation.totalEstimatedCost!.toDouble())} ကျပ်',
                'စုစုပေါင်း ကုန်ကျစရိတ်',
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildSummaryItem(
                '💵 ဝင်ငွေ',
                '${_formatCurrency(simulation.estimatedIncome!.toDouble())} ကျပ်',
                'ခန့်မှန်းဝင်ငွေ',
              ),
              const SizedBox(width: 12),
              _buildSummaryItem(
                '📈 အမြတ်',
                '${_formatCurrency(simulation.estimatedProfit!.toDouble())} ကျပ်',
                'ROI ${simulation.roiPercentage!.toStringAsFixed(1)}%',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value, String subtitle) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.white60, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(double amount) {
    return amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }
}

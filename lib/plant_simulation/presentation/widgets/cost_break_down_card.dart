import 'package:flutter/material.dart';
import 'package:plant_scanner_app/plant_simulation/domain/entity/costBreakDownEntity.dart';

class CostBreakdownCard extends StatelessWidget {
  final CostBreakDownEntity costBreakdown;

  const CostBreakdownCard({super.key, required this.costBreakdown});

  @override
  Widget build(BuildContext context) {
    final totalCost =
        costBreakdown.landPreparation! +
        costBreakdown.fertilizersCost! +
        costBreakdown.growthBoostersCost! +
        costBreakdown.irrigationWaterCost! +
        costBreakdown.laborCost! +
        costBreakdown.miscellaneousCost! +
        costBreakdown.pesticidesCost!;

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
            '💰 ကုန်ကျစရိတ် အသေးစိတ်',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildCostItem(
            '🔄 ထွန်ယက်စရိတ်',
            costBreakdown.landPreparation!.toDouble(),
          ),
          _buildDivider(),
          _buildCostItem(
            '🌱 မျိုးစေ့စရိတ်',
            costBreakdown.seedsCost!.toDouble(),
          ),
          _buildDivider(),
          _buildCostItem(
            '🧪 ဓာတ်မြေသြဇာစရိတ်',
            costBreakdown.fertilizersCost!.toDouble(),
          ),
          _buildDivider(),
          _buildCostItem(
            '🧴 ပိုးသတ်ဆေးစရိတ်',
            costBreakdown.pesticidesCost!.toDouble(),
          ),
          _buildDivider(),
          _buildCostItem(
            '💪 အားဆေးစရိတ်',
            costBreakdown.growthBoostersCost!.toDouble(),
          ),
          _buildDivider(),
          _buildCostItem(
            '💧 ရေသွင်းစရိတ်',
            costBreakdown.irrigationWaterCost!.toDouble(),
          ),
          _buildDivider(),
          _buildCostItem('👨‍🌾 လုပ်သားခ', costBreakdown.laborCost!.toDouble()),
          _buildDivider(),
          _buildCostItem(
            '📦 အထွေထွေစရိတ်',
            costBreakdown.miscellaneousCost!.toDouble(),
          ),
          const Divider(height: 24, thickness: 1.5),
          _buildTotalCost(totalCost.toDouble()),
        ],
      ),
    );
  }

  Widget _buildCostItem(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          Text(
            '${_formatCurrency(amount)} ကျပ်',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCost(double total) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '📊 စုစုပေါင်း',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          '${_formatCurrency(total)} ကျပ်',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(height: 8, color: Colors.grey.shade200);
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

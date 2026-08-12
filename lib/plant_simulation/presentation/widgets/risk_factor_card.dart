import 'package:flutter/material.dart';
import 'package:plant_scanner_app/plant_simulation/domain/entity/risks_factorsEntity.dart';

class RiskFactorsCard extends StatelessWidget {
  final List<RisksFactorEntity> riskFactors;

  const RiskFactorsCard({super.key, required this.riskFactors});

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
            '⚠️ စိုက်ပျိုးရေး အန္တရာယ်များ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...riskFactors.map((item) => _buildRiskItem(item)),
        ],
      ),
    );
  }

  Widget _buildRiskItem(RisksFactorEntity item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getRiskIcon(item.riskType ?? ""),
                color: Colors.orange.shade700,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                item.riskType ?? "",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            item.description ?? "",
            style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.verified, size: 14, color: Colors.green),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '✅ ${item.mitigation}',
                  style: TextStyle(fontSize: 12, color: Colors.green.shade700),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getRiskIcon(String riskType) {
    switch (riskType.toLowerCase()) {
      case 'pests':
        return Icons.bug_report;
      case 'weather':
        return Icons.wb_cloudy;
      case 'disease':
        return Icons.medical_services;
      case 'financial':
        return Icons.attach_money;
      case 'market':
        return Icons.trending_down;
      default:
        return Icons.warning;
    }
  }
}

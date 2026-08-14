import 'package:flutter/material.dart';
import 'package:plant_scanner_app/plant_simulation/domain/entity/farm_simulation_entity.dart';

import 'package:plant_scanner_app/plant_scan/presentation/pages/main_home.dart';
import 'package:plant_scanner_app/plant_simulation/presentation/widgets/build_schedule_task.dart';
import 'package:plant_scanner_app/plant_simulation/presentation/widgets/cost_break_down_card.dart';
import 'package:plant_scanner_app/plant_simulation/presentation/widgets/fertilizer_schedule_card.dart';
import 'package:plant_scanner_app/plant_simulation/presentation/widgets/risk_factor_card.dart';
import 'package:plant_scanner_app/plant_simulation/presentation/widgets/simulation_detail_card.dart';
import 'package:plant_scanner_app/plant_simulation/presentation/widgets/summary_card.dart';

class SimulationSuccessScreen extends StatelessWidget {
  final FarmSimulationEntity simulation;

  const SimulationSuccessScreen({super.key, required this.simulation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          '🌾 စိုက်ပျိုးရေး ခန့်မှန်းချက်',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              _navigateToHome(context);
            },
            icon: const Icon(Icons.home),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Success Header
            _buildSuccessHeader(context),
            const SizedBox(height: 16),

            // ✅ Farm Details
            SimulationDetailCard(simulation: simulation),
            const SizedBox(height: 16),

            // ✅ Summary Card (Yield, Income, Profit)
            SummaryCard(simulation: simulation),
            const SizedBox(height: 16),

            buildScheduleTasks(
              context: context,
              scheduleTasks: simulation.scheduleTasks,
              plantingDate: simulation.createdAt!,
            ),
            const SizedBox(height: 10),

            //✅ Fertilizer Schedule
            FertilizerScheduleCard(
              schedule: simulation.recommendedFertilizerSchedule!,
            ),
            const SizedBox(height: 16),

            // ✅ Cost Breakdown
            CostBreakdownCard(costBreakdown: simulation.costBreakdown!),
            const SizedBox(height: 16),
            //Schedule Tasks

            // ✅ Risk Factors
            RiskFactorsCard(riskFactors: simulation.riskFactors!),
            const SizedBox(height: 16),

            // ✅ Recommendation
            _buildRecommendationCard(simulation),
            const SizedBox(height: 24),

            // ✅ Action Buttons
            _buildActionButtons(context),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ============ Header ============
  Widget _buildSuccessHeader(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.green, Colors.greenAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Container(
            //   padding: const EdgeInsets.all(12),
            //   decoration: const BoxDecoration(
            //     color: Colors.white,
            //     shape: BoxShape.circle,
            //   ),
            //   child: const Icon(
            //     Icons.check_circle,
            //     color: Colors.green,
            //     size: 32,
            //   ),
            // ),
            const SizedBox(width: 30),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'သင်၏ စိုက်ပျိုးရေး ခန့်မှန်းချက်များ',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============ Recommendation Card ============
  Widget _buildRecommendationCard(FarmSimulationEntity simulation) {
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
          const Row(
            children: [
              Icon(Icons.lightbulb, color: Colors.orange, size: 24),
              SizedBox(width: 8),
              Text(
                '💡 စိုက်ပျိုးရေး အကြံပြုချက်များ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            simulation.recommendation!,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // ============ Action Buttons ============
  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _navigateToHome(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.home, color: Colors.white),
            label: const Text(
              'ပင်မစာမျက်နှာ',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // TODO: Share simulation result
              _showShareDialog(context);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.green,
              side: const BorderSide(color: Colors.green),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.share),
            label: const Text(
              'မျှဝေမည်',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  // ============ Navigation ============
  void _navigateToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MainHome()),
      (route) => false,
    );
  }

  // ============ Share Dialog ============
  void _showShareDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('မျှဝေမည်'),
        content: const Text(
          'သင်၏ စိုက်ပျိုးရေး ခန့်မှန်းချက်ကို မျှဝေရန် နည်းလမ်းရွေးပါ။',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('မလုပ်တော့ပါ'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Share via WhatsApp
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            icon: const Icon(Icons.person, color: Colors.white),
            label: const Text('WhatsApp'),
          ),
        ],
      ),
    );
  }
}

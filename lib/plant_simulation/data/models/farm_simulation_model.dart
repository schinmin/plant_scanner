import 'package:plant_scanner_app/plant_simulation/data/models/costBreakDown_model.dart';
import 'package:plant_scanner_app/plant_simulation/data/models/recommend_fertilizer_schedule.dart';
import 'package:plant_scanner_app/plant_simulation/data/models/risk_factor_model.dart';
import 'package:plant_scanner_app/plant_simulation/data/models/schedule_task_model.dart';
import 'package:plant_scanner_app/plant_simulation/domain/entity/farm_simulation_entity.dart';

class FarmSimulationModel extends FarmSimulationEntity {
  const FarmSimulationModel({
    required super.id,
    required super.userId,
    required super.farmName,
    required super.riceType,
    required super.soilType,
    super.season,
    super.farmArea,
    super.plantingDate,
    super.expectedYieldPerAcre,
    super.totalProduction,
    super.costBreakdown,
    super.totalEstimatedCost,
    super.estimatedPricePerUnit,
    super.estimatedIncome,
    super.estimatedProfit,
    super.roiPercentage,
    super.recommendedFertilizerSchedule,
    super.riskFactors,
    required super.scheduleTasks,
    super.recommendation,
    super.createdAt,
    super.updatedAt,
  });

  factory FarmSimulationModel.fromJson(Map<String, dynamic> json) {
    return FarmSimulationModel(
      id: json['_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      farmName: json['farm_name']?.toString() ?? '',
      riceType: json['rice_type']?.toString() ?? '',
      soilType: json['soil_type']?.toString() ?? '',

      season: json['season']?.toString(),

      farmArea: json['farm_area'] ?? 0,

      plantingDate: json['planting_date'] ?? "",

      expectedYieldPerAcre: json['expected_yield_per_acre'] ?? 0,

      totalProduction: json['total_production'] ?? 0,

      costBreakdown: json['cost_breakdown'] != null
          ? CostBreakDownModel.fromJson(
              json['cost_breakdown'] as Map<String, dynamic>,
            )
          : null,

      totalEstimatedCost: json['total_estimated_cost'] ?? 0,

      estimatedPricePerUnit: json['estimated_price_per_unit'] ?? 0,

      estimatedIncome: json['estimated_income'] ?? 0,

      estimatedProfit: json['estimated_profit'] ?? 0,

      roiPercentage: json['roi_percentage'],

      recommendedFertilizerSchedule:
          (json['recommended_fertilizer_schedule'] as List?)
              ?.map(
                (item) => RecommendFertilizerSchedule.fromJson(
                  item as Map<String, dynamic>,
                ),
              )
              .toList(),

      riskFactors: (json['risk_factors'] as List?)
          ?.map(
            (item) => RiskFactorModel.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      scheduleTasks:
          (json['schedule_tasks'] as List?)
              ?.map((item) => ScheduleTaskModel.fromJson(item))
              .toList() ??
          [],

      recommendation: json['recommendation']?.toString(),

      createdAt: (json['createdAt'] != null && json['createdAt'] is String)
          ? DateTime.tryParse(json['createdAt'])
          : null,

      updatedAt: (json['updatedAt'] != null && json['updatedAt'] is String)
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }
}

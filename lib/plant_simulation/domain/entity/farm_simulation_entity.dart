import 'package:equatable/equatable.dart';
import 'package:plant_scanner_app/plant_simulation/domain/entity/costBreakDownEntity.dart';
import 'package:plant_scanner_app/plant_simulation/domain/entity/recomand_fertilizer_scheduleEntity.dart';
import 'package:plant_scanner_app/plant_simulation/domain/entity/risks_factorsEntity.dart';
import 'package:plant_scanner_app/plant_simulation/domain/entity/schedule_task_entity.dart';

class FarmSimulationEntity extends Equatable {
  final String? id;
  final String? userId;
  final String? farmName;
  final String? riceType;
  final String? soilType;
  final String? season;
  final int? farmArea;
  final String? plantingDate;
  final num? expectedYieldPerAcre;
  final num? totalProduction;
  final CostBreakDownEntity? costBreakdown;
  final num? totalEstimatedCost;
  final num? estimatedPricePerUnit;
  final num? estimatedIncome;
  final num? estimatedProfit;
  final num? roiPercentage;
  final List<RecommendFertilizerScheduleEntity>? recommendedFertilizerSchedule;

  final List<RisksFactorEntity>? riskFactors;
  final List<ScheduleTaskEntity> scheduleTasks;
  final String? recommendation;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const FarmSimulationEntity({
    this.id,
    this.userId,
    this.farmName,
    this.riceType,
    this.soilType,
    this.season,
    this.farmArea,
    this.plantingDate,
    this.expectedYieldPerAcre,
    this.totalProduction,
    this.costBreakdown,
    this.totalEstimatedCost,
    this.estimatedPricePerUnit,
    this.estimatedIncome,
    this.estimatedProfit,
    this.roiPercentage,
    this.recommendedFertilizerSchedule,
    this.riskFactors,
    required this.scheduleTasks,
    this.recommendation,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    riceType,
    soilType,
    season,
    farmArea,
    plantingDate,
    expectedYieldPerAcre,
    totalProduction,
    costBreakdown,
    totalEstimatedCost,
    estimatedPricePerUnit,
    estimatedIncome,
    estimatedProfit,
    roiPercentage,
    recommendedFertilizerSchedule,
    riskFactors,
    scheduleTasks,
    recommendation,
    createdAt,
    updatedAt,
  ];
}

// user_id": "6a785306be8c907424f284b8",
//         "farm_name": "A",
//         "rice_type": "နှင်းဆီပင်",
//         "soil_type": "Clay Loam",
//         "season": "မိုးရာသီ",
//         "farm_area": 10,
//         "planting_date": "2026-08-15T00:00:00.000Z",
//         "expected_yield_per_acre": 55,
//         "total_production": 550,
//         "cost_breakdown": {
//             "land_preparation": 300000,
//             "seeds": 350000,
//             "fertilizers": 450000,
//             "pesticides": 200000,
//             "growth_boosters": 100000,
//             "irrigation_water": 150000,
//             "labor": 500000,
//             "miscellaneous": 100000
//         },
//         "total_estimated_cost": 2150000,
//         "estimated_price_per_unit": 1500,
//         "estimated_income": 825000,
//         "estimated_profit": -1325000,
//         "roi_percentage": -61.63,
//         "recommended_fertilizer_schedule": [
//             {
//                 "days_after_planting": 7,
//                 "fertilizer_name": "UREA",
//                 "amount_per_acre": "20 kg",
//                 "_id": "6a78921374bac6bf15a8d9ac"
//             },
//             {
//                 "days_after_planting": 21,
//                 "fertilizer_name": "TSP (Triple Super Phosphate)",
//                 "amount_per_acre": "15 kg",
//                 "_id": "6a78921374bac6bf15a8d9ad"
//             },
//             {
//                 "days_after_planting": 35,
//                 "fertilizer_name": "MOP (Muriate of Potash)",
//                 "amount_per_acre": "15 kg",
//                 "_id": "6a78921374bac6bf15a8d9ae"
//             },
//             {
//                 "days_after_planting": 50,
//                 "fertilizer_name": "ZnSO4 (Zinc Sulfate) or Micronutrients",
//                 "amount_per_acre": "5 kg",
//                 "_id": "6a78921374bac6bf15a8d9af"
//             }
//         ],
//         "risk_factors": [
//             {
//                 "risk_type": "Pest Infestation",
//                 "description": "Rice stem borer and leaf folder can affect yield.",
//                 "mitigation": "Regular monitoring and timely use of recommended pesticides; crop rotation.",
//                 "_id": "6a78921374bac6bf15a8d9b0"
//             },
//             {
//                 "risk_type": "Flooding",
//                 "description": "Excess rain in the monsoon season may lead to waterlogging.",
//                 "mitigation": "Use raised beds or proper drainage systems; avoid planting in flood-prone lowlands.",
//                 "_id": "6a78921374bac6bf15a8d9b1"
//             },
//             {
//                 "risk_type": "Disease",
//                 "description": "Blast disease can damage rice crops.",
//                 "mitigation": "Use disease-resistant varieties; timely fungicide application.",
//                 "_id": "6a78921374bac6bf15a8d9b2"
//             },
//             {
//                 "risk_type": "Price Fluctuation",
//                 "description": "Market price of rice is volatile during harvest season.",
//                 "mitigation": "Consider cooperative selling; store rice for some time to sell at better prices.",
//                 "_id": "6a78921374bac6bf15a8d9b3"
//             }
//         ],
//         "recommendation": "မြတ်စွာ နှင်းဆီပင်တောင်နှင့် ကလေးလိုမ်သည့်မြေများအတွက် မိုးရာသီတွင် ၈လ ၁၅ရက်မှစ၍ စိုက်ပျိုးပါက မြန်မာနိုင်ငံလက်ရှိစိုက်ပျိုးမှုမှုန့်အခြေအနေများအရ တင်ပြပါစရိတ်များနှင့် ရလဒ်များကို တွက်ချက်ထားပါသည်။ မြေထွက်အောင်မြင်သောပြီးနောက် ဓာတုမြေသြဇာကို ကာလခွဲပြီး ထပ်မံဖြန့်ဝေကြပါရန် အထူးသတိပြုပါ။ စားသုံးသူဈေးကွက်သည်တုန်းက မတည်ငြိမ်နိုင်သောကြောင့် ဒေါ်လာသဟဇာတအားနှင့် ပိုမိုကောင်းမွန်သောစျေးကွက်ကိုဖြစ်ပေါ်စေရန် သိုလှောင်ခြင်းနှင့် ပိုမိုထိရောက်သော စိုက်ပျိုးရေးနည်းပညာအသုံးပြုမှုကို ဦးစားပေးပါ။ ပိုးမွှားနှင့် ရာသီဥတုပြဿနာများကို သတိထားကာ မဟာဗျူဟာများနှင့် တိုက်ဖျတ်ရန် လုပ်ဆောင်သင့်ပါသည်။",
//         "_id": "6a78921374bac6bf15a8d9ab",
//         "createdAt": "2026-08-09T14:43:31.415Z",
//         "updatedAt": "2026-08-09T14:43:31.415Z",
//         "__v": 0
//     }

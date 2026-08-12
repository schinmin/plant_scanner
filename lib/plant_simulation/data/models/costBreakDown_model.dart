import 'package:plant_scanner_app/plant_simulation/domain/entity/costBreakDownEntity.dart';

class CostBreakDownModel extends CostBreakDownEntity {
  const CostBreakDownModel(
    final int? landPreparation,
    final int? seedsCost,
    final int? fertilizersCost,
    final int? pesticidesCost,
    final int? growthBoostersCost,
    final int? irrigationWaterCost,
    final int? laborCost,
    final int? miscellaneousCost,
  ) : super(
        landPreparation: landPreparation,
        seedsCost: seedsCost,
        fertilizersCost: fertilizersCost,
        pesticidesCost: pesticidesCost,
        growthBoostersCost: growthBoostersCost,
        irrigationWaterCost: irrigationWaterCost,
        laborCost: laborCost,
        miscellaneousCost: miscellaneousCost,
      );

  factory CostBreakDownModel.fromJson(Map<String, dynamic> json) {
    return CostBreakDownModel(
      json['land_preparation'] ?? 0,
      json['seeds'] ?? 0,
      json['fertilizers'] ?? 0,
      json['pesticides'] ?? 0,
      json['growth_boosters'] ?? 0,
      json['irrigation_water'] ?? 0,
      json['labor'] ?? 0,
      json["miscellaneous"] ?? 0,
    );
  }
}

// "data": {
//         "user_id": "6a785306be8c907424f284b8",
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

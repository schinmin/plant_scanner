import 'package:plant_scanner_app/plant_simulation/domain/entity/recomand_fertilizer_scheduleEntity.dart';

class RecommendFertilizerSchedule extends RecommendFertilizerScheduleEntity {
  const RecommendFertilizerSchedule({
    required super.id,
    super.daysAfterPlanting,
    super.amountPerAcre,
    super.fertilizerName,
  });

  factory RecommendFertilizerSchedule.fromJson(Map<String, dynamic> json) {
    return RecommendFertilizerSchedule(
      id: json['_id'] ?? "",
      daysAfterPlanting: json['days_after_planting'],
      amountPerAcre: json['amount_per_acre'],
      fertilizerName: json["fertilizer_name"],
    );
  }
}

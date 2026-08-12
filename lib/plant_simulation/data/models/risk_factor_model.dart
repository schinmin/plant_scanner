import 'package:plant_scanner_app/plant_simulation/domain/entity/risks_factorsEntity.dart';

class RiskFactorModel extends RisksFactorEntity {
  const RiskFactorModel({
    required super.id,
    required super.description,
    required super.mitigation,
  });

  factory RiskFactorModel.fromJson(Map<String, dynamic> json) {
    return RiskFactorModel(
      id: json['_id'],
      description: json['description'] ?? "",
      mitigation: json['mitigation'] ?? "",
    );
  }
}

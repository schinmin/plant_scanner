import 'package:plant_scanner_app/plant_scan/domain/entity/ai_response.dart';

class AiResponseModel extends AiResponse {
  const AiResponseModel({
    required String recordId,
    required bool success,
    required String diseaseNameEng,
    required String diseaseNameMM,
    required int confidencePercentage,
    required List<String> treatementSteps,
  }) : super(
         recordId: recordId,
         success: success,
         diseaseNameEng: diseaseNameEng,
         diseaseNameMM: diseaseNameMM,
         confidencePercentage: confidencePercentage,
         treatementSteps: treatementSteps,
       );

  factory AiResponseModel.fromJson(Map<String, dynamic> json) {
    return AiResponseModel(
      recordId: json['record_id'] as String,
      success: json['success'],
      diseaseNameEng: json['disease_english'] as String,
      diseaseNameMM: json['disease_myanmar'] as String,
      confidencePercentage: json['confidence_percentage'] as int,
      treatementSteps:
          (json['treatment_steps'] != null && json['treatment_steps'] is List)
          ? List<String>.from(json['treatment_steps'])
          : [],
    );
  }
}

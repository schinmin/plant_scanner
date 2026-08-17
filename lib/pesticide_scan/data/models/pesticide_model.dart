import 'package:plant_scanner_app/pesticide_scan/domain/entity/pesticide_entity.dart';

class PesticideScanModel extends PesticideScanResult {
  const PesticideScanModel({
    required super.success,
    required super.status,
    required super.message,
    required super.guide,
  });

  factory PesticideScanModel.fromJson(Map<String, dynamic> json) {
    return PesticideScanModel(
      success: json['success'] as bool? ?? false,
      status: _safeString(json['status']),
      message: _safeString(json['message']),
      guide: json['guide'] is Map<String, dynamic>
          ? PesticideGuideModel.fromJson(json['guide'] as Map<String, dynamic>)
          : PesticideGuideModel.empty(), // Fallback if guide is missing or invalid
    );
  }
}

class PesticideGuideModel extends PesticideGuide {
  const PesticideGuideModel({
    required super.summary,
    required super.usedFor,
    required super.approvedCrops,
    required super.targetPests,
    required super.howToUse,
    required super.dosage,
    required super.bestApplicationTime,
    required super.safetyPrecautions,
    required super.protectiveEquipment,
    required super.storage,
    required super.firstAid,
    required super.environmentWarning,
    required super.importantNotes,
  });

  factory PesticideGuideModel.fromJson(Map<String, dynamic> json) {
    return PesticideGuideModel(
      summary: _safeString(json['summary']),
      usedFor: _safeString(json['usedFor']),
      approvedCrops: _safeListString(json['approvedCrops']),
      targetPests: _safeListString(json['targetPests']),
      howToUse: _safeListString(json['howToUse']),
      dosage: _safeString(json['dosage']),
      bestApplicationTime: _safeString(json['bestApplicationTime']),
      safetyPrecautions: _safeListString(json['safetyPrecautions']),
      protectiveEquipment: _safeListString(json['protectiveEquipment']),
      storage: _safeString(json['storage']),
      firstAid: _safeString(json['firstAid']),
      environmentWarning: _safeString(json['environmentWarning']),
      importantNotes: _safeListString(json['importantNotes']),
    );
  }

  // Fallback empty model if guide object is null from API
  factory PesticideGuideModel.empty() {
    return const PesticideGuideModel(
      summary: '',
      usedFor: '',
      approvedCrops: [],
      targetPests: [],
      howToUse: [],
      dosage: '',
      bestApplicationTime: '',
      safetyPrecautions: [],
      protectiveEquipment: [],
      storage: '',
      firstAid: '',
      environmentWarning: '',
      importantNotes: [],
    );
  }
}

// ---------------------------------------------------------------------------
// Helper Functions for Safe Parsing
// ---------------------------------------------------------------------------

/// Safely converts any JSON value to a String. If it's a Map or List, it converts
/// it to string instead of crashing with a type subtype exception.
String _safeString(dynamic value) {
  if (value == null) return '';
  if (value is String) return value;
  return value.toString();
}

/// Safely extracts a List<String> regardless of whether items inside are ints,
/// strings, or nested structures.
List<String> _safeListString(dynamic value) {
  if (value is List) {
    return value.map((item) => _safeString(item)).toList();
  }
  return [];
}

import 'package:equatable/equatable.dart';

class PesticideScanResult extends Equatable {
  final bool success;
  final String status;
  final String message;
  final PesticideGuide guide;

  const PesticideScanResult({
    required this.success,
    required this.status,
    required this.message,
    required this.guide,
  });

  @override
  List<Object?> get props => [success, status, message, guide];
}

class PesticideGuide extends Equatable {
  final String summary;
  final String usedFor;
  final List<String> approvedCrops;
  final List<String> targetPests;
  final List<String> howToUse;
  final String dosage;
  final String bestApplicationTime;
  final List<String> safetyPrecautions;
  final List<String> protectiveEquipment;
  final String storage;
  final String firstAid;
  final String environmentWarning;
  final List<String> importantNotes;

  const PesticideGuide({
    required this.summary,
    required this.usedFor,
    required this.approvedCrops,
    required this.targetPests,
    required this.howToUse,
    required this.dosage,
    required this.bestApplicationTime,
    required this.safetyPrecautions,
    required this.protectiveEquipment,
    required this.storage,
    required this.firstAid,
    required this.environmentWarning,
    required this.importantNotes,
  });

  @override
  List<Object?> get props => [
    summary,
    usedFor,
    approvedCrops,
    targetPests,
    howToUse,
    dosage,
    bestApplicationTime,
    safetyPrecautions,
    protectiveEquipment,
    storage,
    firstAid,
    environmentWarning,
    importantNotes,
  ];
}

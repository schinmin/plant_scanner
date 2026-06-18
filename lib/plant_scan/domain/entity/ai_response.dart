import 'package:equatable/equatable.dart';

class AiResponse extends Equatable {
  final String recordId;
  final bool success;
  final String diseaseNameEng;
  final String diseaseNameMM;
  final int confidencePercentage;
  final List<String> treatementSteps;

  const AiResponse({
    required this.recordId,
    required this.success,
    required this.diseaseNameEng,
    required this.diseaseNameMM,
    required this.confidencePercentage,
    required this.treatementSteps,
  });
  @override
  List<Object?> get props => [
    recordId,
    success,
    diseaseNameEng,
    diseaseNameMM,
    confidencePercentage,
    treatementSteps,
  ];
}

// ignore: file_names

import 'package:equatable/equatable.dart';

class RecommendFertilizerScheduleEntity extends Equatable {
  final String id;
  final int? daysAfterPlanting;
  final String? fertilizerName;
  final String? amountPerAcre;

  const RecommendFertilizerScheduleEntity({
    required this.id,
    this.daysAfterPlanting,
    this.fertilizerName,
    this.amountPerAcre,
  });

  @override
  List<Object?> get props => [
    id,
    daysAfterPlanting,
    fertilizerName,
    amountPerAcre,
  ];
}

// {
//                 "days_after_planting": 7,
//                 "fertilizer_name": "UREA",
//                 "amount_per_acre": "20 kg",
//                 "_id": "6a78921374bac6bf15a8d9ac"
//             },

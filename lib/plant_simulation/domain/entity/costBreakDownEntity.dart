import 'package:equatable/equatable.dart';

class CostBreakDownEntity extends Equatable {
  final int? landPreparation;
  final int? seedsCost;
  final int? fertilizersCost;
  final int? pesticidesCost;
  final int? growthBoostersCost;
  final int? irrigationWaterCost;
  final int? laborCost;
  final int? miscellaneousCost;

  const CostBreakDownEntity({
    this.landPreparation,
    this.seedsCost,
    this.fertilizersCost,
    this.pesticidesCost,
    this.growthBoostersCost,
    this.irrigationWaterCost,
    this.laborCost,
    this.miscellaneousCost,
  });

  // int get totalCost {
  //   return (int.tryParse(landPreparation ?? 0) ?? 0) +
  //       (int.tryParse(seedsCost ?? '0') ?? 0) +
  //       (int.tryParse(fertilizersCost ?? '0') ?? 0) +
  //       (int.tryParse(pesticidesCost ?? '0') ?? 0) +
  //       (int.tryParse(growthBoostersCost ?? '0') ?? 0) +
  //       (int.tryParse(irrigationWaterCost ?? '0') ?? 0) +
  //       (int.tryParse(laborCost ?? '0') ?? 0) +
  //       (int.tryParse(miscellaneousCost ?? '0') ?? 0);
  // }

  // Map<String, int> get costBreakDownMap => {
  //   'land_preparation': i ?? 0,
  //   'seeds': int.parse(seedsCost ?? '0'),
  //   'fertilizers ': int.parse(fertilizersCost ?? '0'),
  //   'pesticides': pesticidesCost != null ? int.parse(pesticidesCost!) : 0,
  //   'growth_boosters': growthBoostersCost != null
  //       ? int.parse(growthBoostersCost!)
  //       : 0,
  //   'irrigation_water': irrigationWaterCost != null
  //       ? int.parse(irrigationWaterCost!)
  //       : 0,
  //   'labor': laborCost != null ? int.parse(laborCost!) : 0,
  //   'miscellaneous': miscellaneousCost != null
  //       ? int.parse(miscellaneousCost!)
  //       : 0,
  // };

  // String get largeExpenseCost {
  //   final Map costMap = costBreakDownMap;
  //   final sortedEntries = costMap.entries.toList()
  //     ..sort((a, b) => b.value.compareTo(a.value));
  //   final largestEntry = sortedEntries.first;
  //   return largestEntry.key;
  // }

  @override
  List<Object?> get props => [
    landPreparation,
    seedsCost,
    fertilizersCost,
    pesticidesCost,
    growthBoostersCost,
    irrigationWaterCost,
    laborCost,
    miscellaneousCost,
  ];
}

// land_preparation": 300000,
//             "seeds": 350000,
//             "fertilizers": 450000,
//             "pesticides": 200000,
//             "growth_boosters": 100000,
//             "irrigation_water": 150000,
//             "labor": 500000,
//             "miscellaneous": 100000

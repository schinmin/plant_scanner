import 'package:equatable/equatable.dart';

class CropMarket extends Equatable {
  final String id;
  final String name;
  final String location;
  final String marketPlace;
  final String? minPrice;
  final String? maxPrice;

  final String? currency;

  final String? unit;

  final DateTime? updatedAt;

  const CropMarket({
    required this.id,
    required this.name,
    required this.location,
    required this.marketPlace,
    this.minPrice,
    this.maxPrice,
    this.currency,
    this.unit,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    location,
    marketPlace,
    minPrice,
    maxPrice,
    currency,
    unit,
    updatedAt,
  ];
}

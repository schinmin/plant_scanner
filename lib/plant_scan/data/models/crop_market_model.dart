import 'package:json_annotation/json_annotation.dart';
import 'package:plant_scanner_app/plant_scan/domain/entity/crop_market.dart';

@JsonSerializable()
class CropMarketModel extends CropMarket {
  CropMarketModel({
    required super.id,
    required super.name,
    required super.location,
    required super.marketPlace,
    super.minPrice,
    super.maxPrice,
    super.currency,
    super.quantity,
    super.unit,
    super.updatedAt,
  });

  factory CropMarketModel.fromJson(Map<String, dynamic> json) {
    return CropMarketModel(
      id: json['_id'],
      name: json['name'] as String,
      location: json['location'] as String,
      marketPlace: (json['market_place'] ?? 'N/A') as String,
      minPrice: json['min_price'] ?? 0,
      maxPrice: json['max_price'] ?? 0,
      currency: json['currency'] as String,

      quantity: json["quantity"] as String,

      unit: json['unit'] as String,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );
  }
}

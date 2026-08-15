import 'package:json_annotation/json_annotation.dart';
import 'package:plant_scanner_app/plant_scan/domain/entity/crop_market.dart';

@JsonSerializable()
class CropMarketModel extends CropMarket {
  const CropMarketModel({
    required super.id,
    required super.name,
    required super.location,
    required super.marketPlace,
    super.minPrice,
    super.maxPrice,
    super.currency,
    super.unit,
    super.updatedAt,
  });

  factory CropMarketModel.fromJson(Map<String, dynamic> json) {
    return CropMarketModel(
      id: _asString(json['_id']),
      name: _asString(json['name']),
      location: _asString(json['location']),
      marketPlace: _asString(json['market_place']),
      minPrice: _asNullableString(json['min_price']),
      maxPrice: _asNullableString(json['max_price']),
      currency: _asNullableString(json['currency']),
      unit: _asNullableString(json['unit']),
      updatedAt: _asDateTime(json['updatedAt']),
    );
  }

  static String _asString(dynamic value) {
    return value?.toString().trim() ?? '';
  }

  static String? _asNullableString(dynamic value) {
    final normalized = value?.toString().trim();
    return normalized == null || normalized.isEmpty ? null : normalized;
  }

  static DateTime? _asDateTime(dynamic value) {
    final normalized = _asNullableString(value);
    return normalized == null ? null : DateTime.tryParse(normalized);
  }
}

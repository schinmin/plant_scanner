import 'package:flutter_test/flutter_test.dart';
import 'package:plant_scanner_app/plant_scan/data/models/crop_market_model.dart';

void main() {
  group('CropMarketModel.fromJson', () {
    test('normalizes numeric prices and identifiers to strings', () {
      final model = CropMarketModel.fromJson({
        '_id': 42,
        'name': 'Rice',
        'location': 'Yangon',
        'market_place': 'Bayint Naung',
        'min_price': 1200,
        'max_price': 1450.5,
        'currency': 'MMK',
        'unit': 'viss',
        'updatedAt': '2026-08-15T08:30:00.000Z',
      });

      expect(model.id, '42');
      expect(model.minPrice, '1200');
      expect(model.maxPrice, '1450.5');
      expect(model.updatedAt, DateTime.utc(2026, 8, 15, 8, 30));
    });

    test('uses safe values for missing fields and an invalid date', () {
      final model = CropMarketModel.fromJson({
        'min_price': null,
        'max_price': '',
        'updatedAt': 'not-a-date',
      });

      expect(model.id, isEmpty);
      expect(model.name, isEmpty);
      expect(model.location, isEmpty);
      expect(model.marketPlace, isEmpty);
      expect(model.minPrice, isNull);
      expect(model.maxPrice, isNull);
      expect(model.currency, isNull);
      expect(model.unit, isNull);
      expect(model.updatedAt, isNull);
    });
  });
}

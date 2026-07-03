import 'package:dartz/dartz.dart';
import 'package:plant_scanner_app/core/error/failure.dart';
import 'package:plant_scanner_app/plant_scan/domain/entity/crop_market.dart';

abstract class CropMarketRepository {
  Future<Either<Failure, List<CropMarket>>> getCropMarkets(int page);
}

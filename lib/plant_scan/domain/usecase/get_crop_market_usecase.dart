import 'package:dartz/dartz.dart';
import 'package:plant_scanner_app/core/error/failure.dart';
import 'package:plant_scanner_app/plant_scan/domain/entity/crop_market.dart';
import 'package:plant_scanner_app/plant_scan/domain/repository/crop_market_repository.dart';

class GetCropMarketUseCase {
  final CropMarketRepository repository;

  GetCropMarketUseCase(this.repository);

  Future<Either<Failure, List<CropMarket>>> call({
    required int page,
    required String search,
  }) async {
    return await repository.getCropMarkets(page: page, search: search);
  }
}

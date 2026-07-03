import 'package:dartz/dartz.dart';
import 'package:plant_scanner_app/core/error/failure.dart';
import 'package:plant_scanner_app/plant_scan/data/datasources/get_crop_market_datasource.dart';
import 'package:plant_scanner_app/plant_scan/domain/entity/crop_market.dart';
import 'package:plant_scanner_app/plant_scan/domain/repository/crop_market_repository.dart';

class GetCropMarketRepolImpl extends CropMarketRepository {
  final GetCropMarketDatasource getCropMarketDatasource;

  GetCropMarketRepolImpl(this.getCropMarketDatasource);

  @override
  Future<Either<Failure, List<CropMarket>>> getCropMarkets(int page) async {
    final result = await getCropMarketDatasource.call(page);

    return result.fold(
      (failure) => Left(failure),
      (cropPrices) => Right(cropPrices),
    );
  }
}

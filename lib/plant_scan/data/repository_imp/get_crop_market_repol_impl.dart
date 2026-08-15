import 'package:dartz/dartz.dart';
import 'package:plant_scanner_app/core/error/failure.dart';
import 'package:plant_scanner_app/core/network/network_info.dart';
import 'package:plant_scanner_app/plant_scan/data/datasources/get_crop_market_datasource.dart';
import 'package:plant_scanner_app/plant_scan/domain/entity/crop_market.dart';
import 'package:plant_scanner_app/plant_scan/domain/repository/crop_market_repository.dart';

class GetCropMarketRepolImpl extends CropMarketRepository {
  final GetCropMarketDatasource getCropMarketDatasource;
  final NetworkInfo networkInfo;

  GetCropMarketRepolImpl(this.getCropMarketDatasource, this.networkInfo);

  @override
  Future<Either<Failure, List<CropMarket>>> getCropMarkets({
    required int page,
    required String search,
  }) async {
    if (await networkInfo.isConnected) {
      final result = await getCropMarketDatasource.call(
        page: page,
        search: search,
      );

      return result.fold(
        (failure) => Left(failure),
        (cropPrices) => Right(cropPrices),
      );
    } else {
      return Left(Failure("အင်တာနက်ပြတ်တောက်နေပါသည်။ ပြန်လည်ချိတ်ဆက်ပေးပါ။"));
    }
  }
}

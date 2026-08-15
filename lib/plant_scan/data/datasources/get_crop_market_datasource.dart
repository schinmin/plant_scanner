import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:plant_scanner_app/core/constant/api_constant.dart';
import 'package:plant_scanner_app/core/error/failure.dart';
import 'package:plant_scanner_app/core/network/api_service.dart';
import 'package:plant_scanner_app/plant_scan/data/models/crop_market_model.dart';

abstract class GetCropMarketDatasource {
  Future<Either<Failure, List<CropMarketModel>>> call({
    required int page,
    required String search,
  });
}

class GetCropMarket extends GetCropMarketDatasource {
  final ApiService apiService;

  GetCropMarket(this.apiService);

  @override
  Future<Either<Failure, List<CropMarketModel>>> call({
    required int page,
    required String search,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {"page": page, "limit": 10};
      if (search.trim().isNotEmpty) {
        queryParams['search'] = search.trim();
      } else {
        queryParams['search'] = "";
      }
      final response = await apiService.dio.get(
        cropMarketEndPoint,
        queryParameters: queryParams,
      );

      final responseData = response.data;
      if (response.statusCode == 200 &&
          responseData is Map<String, dynamic> &&
          responseData['success'] == true) {
        final rawCropMarkets = responseData['data'];
        if (rawCropMarkets is! List) {
          return Left(Failure('Invalid crop price response'));
        }

        final cropPrices = <CropMarketModel>[];
        for (final rawCropMarket in rawCropMarkets) {
          if (rawCropMarket is! Map) continue;
          try {
            cropPrices.add(
              CropMarketModel.fromJson(
                Map<String, dynamic>.from(rawCropMarket),
              ),
            );
          } catch (_) {
            continue;
          }
        }

        if (cropPrices.isEmpty && rawCropMarkets.isNotEmpty) {
          return Left(Failure('Invalid crop price records'));
        }
        return Right(cropPrices);
      }

      final message = responseData is Map<String, dynamic>
          ? responseData['message']?.toString()
          : null;
      return Left(Failure(message ?? 'Could not load crop prices'));
    } catch (_, stackTrace) {
      debugPrint('Fetching crop prices failed unexpectedly');
      debugPrintStack(stackTrace: stackTrace);
      return Left(Failure('Could not load crop prices'));
    }
  }
}

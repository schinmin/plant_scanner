import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
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
      //final dio = Dio();

      final Map<String, dynamic> queryParams = {"page": page, "limit": 10};
      if (search.trim().isNotEmpty) {
        queryParams['search'] = search.trim();
      } else {
        queryParams['search'] = "";
      }
      final response = await apiService.dio.get(
        'https://argitech-production.up.railway.app/api/crop-prices',
        queryParameters: queryParams,
      );
      debugPrint('Response: ${response.statusCode} ${response.data}');
      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> cropmarkets = response.data['data'];
        debugPrint("Type of min and max respoo");
        final List<CropMarketModel> cropPrices = cropmarkets
            .map((crop) => CropMarketModel.fromJson(crop))
            .toList();
        debugPrint("Market_place ${cropPrices[1].marketPlace}");
        return Right(cropPrices);
      } else {
        return Left(response.data['success']);
      }
    } catch (e, stackTrace) {
      debugPrint("Stack Trace : $stackTrace");
      return Left(Failure("Server Error : ${e.toString()}"));
    }
  }
}

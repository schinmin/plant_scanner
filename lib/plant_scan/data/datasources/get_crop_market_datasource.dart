import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:plant_scanner_app/core/constant/api_constant.dart';
import 'package:plant_scanner_app/core/error/failure.dart';
import 'package:plant_scanner_app/core/network/api_service.dart';
import 'package:plant_scanner_app/plant_scan/data/models/crop_market_model.dart';

abstract class GetCropMarketDatasource {
  Future<Either<Failure, List<CropMarketModel>>> call(int page);
}

class GetCropMarket extends GetCropMarketDatasource {
  final ApiService apiService;

  GetCropMarket(this.apiService);

  @override
  Future<Either<Failure, List<CropMarketModel>>> call(int page) async {
    try {
      final dio = Dio();
      final response = await dio.get(
        'https://argitech-ts3a.onrender.com/api/crop-prices',
        queryParameters: {"page": page},
      );
      debugPrint('Response: ${response.statusCode} ${response.data}');
      if (response.statusCode == 200 && response.data['success'] == true) {
        final List<dynamic> cropmarkets = response.data['data'];

        final List<CropMarketModel> cropPrices = cropmarkets
            .map((crop) => CropMarketModel.fromJson(crop))
            .toList();
        return Right(cropPrices);
      } else {
        return Left(response.data['success']);
      }
    } catch (e) {
      return Left(Failure("Server Error : ${e.toString()}"));
    }
  }
}

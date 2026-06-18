import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:plant_scanner_app/core/error/failure.dart';
import 'package:plant_scanner_app/plant_scan/data/datasources/get_response_datasource.dart';
import 'package:plant_scanner_app/plant_scan/domain/entity/ai_response.dart';
import 'package:plant_scanner_app/plant_scan/domain/repository/disease_repository.dart';

class GetDiseaseRepolImpl extends DiseaseRepository {
  final GetResponseDataSource dataSource;
  GetDiseaseRepolImpl(this.dataSource);

  @override
  Future<Either<Failure, AiResponse>> getResponse(String imagePath) async {
    try {
      final response = await dataSource.getResponse(imagePath);
      debugPrint('Repository received response: $response');
      return Right(response);
    } catch (e) {
      return Left(Failure('Failed to get response: $e'));
    }
  }
}

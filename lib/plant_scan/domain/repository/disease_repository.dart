import 'package:dartz/dartz.dart';
import 'package:plant_scanner_app/core/error/failure.dart';
import 'package:plant_scanner_app/plant_scan/domain/entity/ai_response.dart';

abstract class DiseaseRepository {
  Future<Either<Failure, AiResponse>> getResponse(String imagePath);
}

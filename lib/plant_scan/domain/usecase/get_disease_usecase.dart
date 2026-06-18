import 'package:dartz/dartz.dart';
import 'package:plant_scanner_app/core/error/failure.dart';
import 'package:plant_scanner_app/plant_scan/domain/entity/ai_response.dart';
import 'package:plant_scanner_app/plant_scan/domain/repository/disease_repository.dart';

class GetDiseaseUseCase {
  final DiseaseRepository repository;

  GetDiseaseUseCase(this.repository);

  Future<Either<Failure, AiResponse>> call(String imagePath) async {
    return await repository.getResponse(imagePath);
  }
}

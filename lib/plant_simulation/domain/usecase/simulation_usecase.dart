import 'package:dartz/dartz.dart';
import 'package:plant_scanner_app/core/error/failure.dart';
import 'package:plant_scanner_app/plant_simulation/domain/entity/farm_simulation_entity.dart';
import 'package:plant_scanner_app/plant_simulation/domain/repository/simulation_repository.dart';

class SimulationUsecase {
  final SimulationRepository simulationRepository;

  SimulationUsecase(this.simulationRepository);

  Future<Either<Failure, FarmSimulationEntity>> createSimulation({
    required String farmName,
    required String plantType,
    required String soilType,
    required String plantingArea,
    required String plantingDate,
  }) {
    return simulationRepository.createFarmSimulation(
      farmName: farmName,
      plantType: plantType,
      soilType: soilType,
      plantingArea: plantingArea,
      plantingDate: plantingDate,
    );
  }
}

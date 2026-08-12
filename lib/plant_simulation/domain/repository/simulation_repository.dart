import 'package:dartz/dartz.dart';
import 'package:plant_scanner_app/core/error/failure.dart';
import 'package:plant_scanner_app/plant_simulation/domain/entity/farm_simulation_entity.dart';

abstract class SimulationRepository {
  Future<Either<Failure, FarmSimulationEntity>> createFarmSimulation({
    required String farmName,
    required String plantType,
    required String soilType,
    required String plantingArea,
    required String plantingDate,
  });

  Future<Either<Failure, FarmSimulationEntity>> getFarmSimulation();
}

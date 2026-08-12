import 'package:dartz/dartz.dart';
import 'package:plant_scanner_app/core/error/failure.dart';
import 'package:plant_scanner_app/plant_simulation/data/datasources/simulation_datasources.dart';
import 'package:plant_scanner_app/plant_simulation/domain/entity/farm_simulation_entity.dart';
import 'package:plant_scanner_app/plant_simulation/domain/repository/simulation_repository.dart';

class SimulationRepositoryImpl implements SimulationRepository {
  final SimulationDatasources simulationDataSource;

  SimulationRepositoryImpl(this.simulationDataSource);

  @override
  Future<Either<Failure, FarmSimulationEntity>> createFarmSimulation({
    required String farmName,
    required String plantType,
    required String soilType,
    required String plantingArea,
    required String plantingDate,
  }) async {
    return await simulationDataSource.createSimulation(
      farmName: farmName,
      plantType: plantType,
      soilType: soilType,
      plantArea: plantingArea,
      plantingDate: plantingDate,
    );
  }

  @override
  Future<Either<Failure, FarmSimulationEntity>> getFarmSimulation() {
    // TODO: implement getFarmSimulation
    throw UnimplementedError();
  }
}

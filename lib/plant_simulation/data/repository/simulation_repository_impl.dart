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
    required String location,
    required String season,
  }) async {
    return await simulationDataSource.createSimulation(
      farmName: farmName,
      plantType: plantType,
      soilType: soilType,
      plantArea: plantingArea,
      plantingDate: plantingDate,
      season: season,
      location: location,
    );
  }

  @override
  Future<Either<Failure, List<FarmSimulationEntity>>>
  getFarmSimulation() async {
    return await simulationDataSource.getSimulation();
  }

  @override
  Future<Either<Failure, Unit>> deleteFarmSimulation(String id) async {
    return await simulationDataSource.deleteSimulation(id);
  }
}

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plant_scanner_app/core/error/failure.dart';
import 'package:plant_scanner_app/plant_simulation/domain/entity/farm_simulation_entity.dart';
import 'package:plant_scanner_app/plant_simulation/domain/repository/simulation_repository.dart';
import 'package:plant_scanner_app/plant_simulation/domain/usecase/simulation_usecase.dart';
import 'package:plant_scanner_app/plant_simulation/presentation/bloc/bloc/simulation_bloc.dart';

void main() {
  const simulation = FarmSimulationEntity(
    id: 'simulation-1',
    farmName: 'Test farm',
    scheduleTasks: [],
  );

  test('deleting a simulation removes it from the loaded list', () async {
    final repository = _FakeSimulationRepository([simulation]);
    final bloc = SimulationBloc(SimulationUsecase(repository));

    final loadExpectation = expectLater(
      bloc.stream,
      emitsInOrder([
        isA<SimulationsListLoading>(),
        isA<SimulationsListLoaded>(),
      ]),
    );
    bloc.add(GetSimulationEvent());
    await loadExpectation;

    final deleteExpectation = expectLater(
      bloc.stream,
      emitsInOrder([
        isA<SimulationDeleteInProgress>(),
        isA<SimulationDeleteSuccess>().having(
          (state) => state.farmSimulations,
          'farmSimulations',
          isEmpty,
        ),
      ]),
    );
    bloc.add(DeleteSimulationEvent(id: simulation.id!));
    await deleteExpectation;

    expect(repository.deletedId, simulation.id);
    await bloc.close();
  });
}

class _FakeSimulationRepository implements SimulationRepository {
  _FakeSimulationRepository(this.simulations);

  final List<FarmSimulationEntity> simulations;
  String? deletedId;

  @override
  Future<Either<Failure, List<FarmSimulationEntity>>>
  getFarmSimulation() async => Right(simulations);

  @override
  Future<Either<Failure, Unit>> deleteFarmSimulation(String id) async {
    deletedId = id;
    return const Right(unit);
  }

  @override
  Future<Either<Failure, FarmSimulationEntity>> createFarmSimulation({
    required String farmName,
    required String plantType,
    required String soilType,
    required String plantingArea,
    required String plantingDate,
    required String location,
    required String season,
  }) {
    throw UnimplementedError();
  }
}

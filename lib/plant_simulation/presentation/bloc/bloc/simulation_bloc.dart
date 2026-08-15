import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:plant_scanner_app/core/error/failure.dart';
import 'package:plant_scanner_app/plant_simulation/domain/entity/farm_simulation_entity.dart';
import 'package:plant_scanner_app/plant_simulation/domain/usecase/simulation_usecase.dart';

part 'simulation_event.dart';
part 'simulation_state.dart';

class SimulationBloc extends Bloc<SimulationEvent, SimulationState> {
  final SimulationUsecase simulationUsecase;
  SimulationBloc(this.simulationUsecase) : super(SimulationInitial()) {
    on<CreateSimulationEvent>(_onCreateSimulation);
    on<GetSimulationEvent>(_onGetSimulation);
  }

  Future<void> _onCreateSimulation(
    CreateSimulationEvent event,
    Emitter<SimulationState> emit,
  ) async {
    emit(SimulationLoading());

    try {
      final simulation = await simulationUsecase.createSimulation(
        farmName: event.farmName,
        plantType: event.plantType,
        plantingArea: event.plantArea,
        soilType: event.soilType,
        plantingDate: event.plantingdate,
        location: event.location,
        season: event.season,
      );
      simulation.fold(
        (failure) => emit(SimulationLoadedError(message: Failure("$failure"))),

        (simulation) => emit(SimulationLoaded(farmSimulation: simulation)),
      );
    } catch (e) {
      emit(SimulationLoadedError(message: Failure("Error : ${e.toString()}")));
    }
  }

  ////GetSimulation
  ///
  Future<void> _onGetSimulation(
    GetSimulationEvent event,
    Emitter<SimulationState> emit,
  ) async {
    try {
      final result = await simulationUsecase.getSimulation();

      result.fold(
        (error) => emit(SimulationLoadedError(message: error)),
        (result) => emit(GetSimulationData(result)),
      );
    } catch (e) {
      emit(SimulationLoadedError(message: Failure("Error ${e.toString()}")));
    }
  }
}

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
    on<ResetSimulationEvent>(_onResetSimulation);
  }

  Future<void> _onCreateSimulation(
    CreateSimulationEvent event,
    Emitter<SimulationState> emit,
  ) async {
    emit(CreateSimulationLoading());

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
        (failure) => emit(CreateSimulationFailure(message: failure)),
        (result) => emit(CreateSimulationSuccess(farmSimulation: result)),
      );
    } catch (e) {
      emit(CreateSimulationFailure(message: Failure('Error : ${e.toString()}')));
    }
  }

  Future<void> _onGetSimulation(
    GetSimulationEvent event,
    Emitter<SimulationState> emit,
  ) async {
    emit(SimulationsListLoading());

    try {
      final result = await simulationUsecase.getSimulation();

      result.fold(
        (error) => emit(SimulationsListFailure(message: error)),
        (simulations) => emit(SimulationsListLoaded(simulations)),
      );
    } catch (e) {
      emit(
        SimulationsListFailure(message: Failure('Error ${e.toString()}')),
      );
    }
  }

  void _onResetSimulation(
    ResetSimulationEvent event,
    Emitter<SimulationState> emit,
  ) {
    emit(SimulationInitial());
  }
}

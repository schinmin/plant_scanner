import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
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
      );
      simulation.fold(
        (failure) => emit(SimulationLoadedError(message: Failure("$failure"))),

        (simulation) => emit(SimulationLoaded(farmSimulation: simulation)),
      );
    } catch (e) {
      emit(SimulationLoadedError(message: Failure("Error : ${e.toString()}")));
    }
  }
}

part of 'simulation_bloc.dart';

@immutable
sealed class SimulationState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class SimulationInitial extends SimulationState {
  SimulationInitial();
}

final class SimulationLoading extends SimulationState {
  SimulationLoading();
}

final class SimulationLoaded extends SimulationState {
  final FarmSimulationEntity farmSimulation;

  SimulationLoaded({required this.farmSimulation});

  @override
  List<Object?> get props => [farmSimulation];
}

final class SimulationLoadedError extends SimulationState {
  final Failure message;

  SimulationLoadedError({required this.message});

  @override
  List<Object?> get props => [message];
}

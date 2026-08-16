part of 'simulation_bloc.dart';

@immutable
sealed class SimulationState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class SimulationInitial extends SimulationState {
  SimulationInitial();
}

final class CreateSimulationLoading extends SimulationState {
  CreateSimulationLoading();
}

final class CreateSimulationSuccess extends SimulationState {
  final FarmSimulationEntity farmSimulation;

  CreateSimulationSuccess({required this.farmSimulation});

  @override
  List<Object?> get props => [farmSimulation];
}

final class CreateSimulationFailure extends SimulationState {
  final Failure message;

  CreateSimulationFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

final class SimulationsListLoading extends SimulationState {
  SimulationsListLoading();
}

final class SimulationsListLoaded extends SimulationState {
  final List<FarmSimulationEntity> farmSimulations;

  SimulationsListLoaded(this.farmSimulations);

  @override
  List<Object?> get props => [farmSimulations];
}

final class SimulationsListFailure extends SimulationState {
  final Failure message;

  SimulationsListFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

final class DeleteSimulationLoading extends SimulationState {
  DeleteSimulationLoading();
}

final class DeleteSimulationSuccess extends SimulationState {
  final String message;

  DeleteSimulationSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

final class DeleteSimulationFailure extends SimulationState {
  final Failure message;

  DeleteSimulationFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

part of 'simulation_bloc.dart';

@immutable
sealed class SimulationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateSimulationEvent extends SimulationEvent {
  final String farmName;
  final String plantType;
  final String soilType;
  final String plantArea;
  final String plantingdate;
  CreateSimulationEvent({
    required this.farmName,
    required this.plantType,
    required this.soilType,
    required this.plantArea,
    required this.plantingdate,
  });
}

class GetSimulationEvent extends SimulationEvent {
  GetSimulationEvent();
}

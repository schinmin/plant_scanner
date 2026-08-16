part of 'simulation_bloc.dart';

@immutable
sealed class SimulationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateSimulationEvent extends SimulationEvent {
  final String farmName;
  final String plantType;
  final String soilType;
  final String plantArea;
  final String plantingdate;
  final String location;
  final String season;

  CreateSimulationEvent({
    required this.farmName,
    required this.plantType,
    required this.soilType,
    required this.plantArea,
    required this.plantingdate,
    required this.location,
    required this.season,
  });

  @override
  List<Object?> get props => [
    farmName,
    plantType,
    soilType,
    plantArea,
    plantingdate,
    location,
    season,
  ];
}

class GetSimulationEvent extends SimulationEvent {
  GetSimulationEvent();
}

class DeleteSimulationEvent extends SimulationEvent {
  final String id;

  DeleteSimulationEvent({required this.id});

  @override
  List<Object?> get props => [id];
}

class ResetSimulationEvent extends SimulationEvent {
  ResetSimulationEvent();
}

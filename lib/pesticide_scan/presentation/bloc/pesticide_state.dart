import 'package:equatable/equatable.dart';
import 'package:plant_scanner_app/pesticide_scan/domain/entity/pesticide_entity.dart';

abstract class PesticideState extends Equatable {
  const PesticideState();

  @override
  List<Object?> get props => [];
}

class PesticideInitial extends PesticideState {}

class PesticideLoading extends PesticideState {}

class PesticideSuccess extends PesticideState {
  final PesticideScanResult result;

  const PesticideSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class PesticideFailure extends PesticideState {
  final String message;

  const PesticideFailure(this.message);

  @override
  List<Object?> get props => [message];
}

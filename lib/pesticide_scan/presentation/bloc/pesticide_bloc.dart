import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plant_scanner_app/pesticide_scan/domain/usecase/pesticide_usecase.dart';
import 'pesticide_event.dart';
import 'pesticide_state.dart';

class PesticideBloc extends Bloc<PesticideEvent, PesticideState> {
  final ScanPesticideUseCase scanPesticideUseCase;

  PesticideBloc({required this.scanPesticideUseCase})
    : super(PesticideInitial()) {
    on<ScanPesticideEvent>(_onScanPesticide);
    on<ResetPesticideEvent>(_onResetPesticide);
  }

  Future<void> _onScanPesticide(
    ScanPesticideEvent event,
    Emitter<PesticideState> emit,
  ) async {
    emit(PesticideLoading());

    final result = await scanPesticideUseCase(event.imageFile);

    result.fold(
      (failure) => emit(PesticideFailure(failure.message)),
      (scanData) => emit(PesticideSuccess(scanData)),
    );
  }

  void _onResetPesticide(
    ResetPesticideEvent event,
    Emitter<PesticideState> emit,
  ) {
    emit(PesticideInitial());
  }
}

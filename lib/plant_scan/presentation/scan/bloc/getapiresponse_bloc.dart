import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_scanner_app/plant_scan/domain/entity/ai_response.dart';
import 'package:plant_scanner_app/plant_scan/domain/usecase/get_disease_usecase.dart';

part 'getapiresponse_events.dart';
part 'getapiresponse_state.dart';

class GetapiresponseBloc
    extends Bloc<GetapiresponseEvent, GetapiresponseState> {
  final GetDiseaseUseCase getDiseaseUseCase;

  GetapiresponseBloc(this.getDiseaseUseCase) : super(GetapiresponseInitial()) {
    on<PickAndScanEvent>(_onPickAndScanEvent);
  }

  Future<void> _onPickAndScanEvent(
    PickAndScanEvent event,
    Emitter<GetapiresponseState> emit,
  ) async {
    final image = event.imagePath;

    emit(GetapiresponseLoading());

    final result = await getDiseaseUseCase(image);
    result.fold(
      (failure) => emit(GetapiresponseFailure(failure.message)),
      (response) => emit(GetapiresponseSuccess(response)),
    );
  }
}

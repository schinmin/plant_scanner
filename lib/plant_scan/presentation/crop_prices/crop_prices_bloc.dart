import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:plant_scanner_app/plant_scan/domain/entity/crop_market.dart';
import 'package:plant_scanner_app/plant_scan/domain/usecase/get_crop_market_usecase.dart';

part 'crop_prices_events.dart';
part 'crop_prices_state.dart';

class CropPricesBloc extends Bloc<CropPricesEvent, CropPricesState> {
  final GetCropMarketUseCase getCropMarketUseCase;
  CropPricesBloc(this.getCropMarketUseCase) : super(const CropPricesState()) {
    on<GetCropMarketEvent>(_getCropMarket);
  }

  Future<void> _getCropMarket(
    GetCropMarketEvent event,
    Emitter<CropPricesState> emit,
  ) async {
    if (event.page == 1) {
      emit(CropPricesLoadingState());
    }
    final result = await getCropMarketUseCase.call(
      page: event.page,
      search: event.search,
    );

    result.fold(
      (failure) => emit(CropPricesLoadedErrorState("Error ${failure.message}")),
      (response) {
        final currentList = (state is CropPricesLoadedState && event.page > 1)
            ? (state as CropPricesLoadedState).cropmarkets
            : <CropMarket>[];

        final newList = [...currentList, ...response];
        final hasMore = response.length >= 10;

        emit(CropPricesLoadedState(newList, hasMore, newList.length));
      },
    );
  }
}

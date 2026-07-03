part of 'crop_prices_bloc.dart';

abstract class CropPricesEvent extends Equatable {
  const CropPricesEvent();

  @override
  List<Object> get props => [];
}

class GetCropMarketEvent extends CropPricesEvent {
  const GetCropMarketEvent();

  @override
  List<Object> get props => [];
}

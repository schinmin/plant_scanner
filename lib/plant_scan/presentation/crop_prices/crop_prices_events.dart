part of 'crop_prices_bloc.dart';

abstract class CropPricesEvent extends Equatable {
  const CropPricesEvent();

  @override
  List<Object> get props => [];
}

class GetCropMarketEvent extends CropPricesEvent {
  final int page;
  final String search;
  const GetCropMarketEvent({required this.page, required this.search});

  @override
  List<Object> get props => [];
}

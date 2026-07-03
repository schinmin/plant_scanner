part of 'crop_prices_bloc.dart';

class CropPricesState extends Equatable {
  const CropPricesState();
  @override
  List<Object?> get props => [];
}

class CropPricesInitialState extends CropPricesState {}

class CropPricesLoadingState extends CropPricesState {}

class CropPricesLoadedState extends CropPricesState {
  final List<CropMarket> cropmarkets;

  const CropPricesLoadedState(this.cropmarkets);

  @override
  List<Object?> get props => [cropmarkets];
}

class CropPricesLoadedErrorState extends CropPricesState {
  final String errorMessage;

  const CropPricesLoadedErrorState(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

part of 'getapiresponse_bloc.dart';

abstract class GetapiresponseEvent extends Equatable {
  const GetapiresponseEvent();

  @override
  List<Object> get props => [];
}

class PickAndScanEvent extends GetapiresponseEvent {
  final String imagePath;
  const PickAndScanEvent(this.imagePath);

  @override
  List<Object> get props => [];
}

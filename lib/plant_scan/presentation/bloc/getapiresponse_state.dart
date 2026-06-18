part of 'getapiresponse_bloc.dart';

enum GetapiresponseStatus { initial, loading, success, failure }

class GetapiresponseState extends Equatable {
  const GetapiresponseState();

  @override
  List<Object> get props => [];
}

class GetapiresponseInitial extends GetapiresponseState {}

class GetapiresponseLoading extends GetapiresponseState {}

class GetapiresponseSuccess extends GetapiresponseState {
  final AiResponse aiResponse;
  const GetapiresponseSuccess(this.aiResponse);

  @override
  List<Object> get props => [aiResponse];
}

class GetapiresponseFailure extends GetapiresponseState {
  final String errorMessage;
  const GetapiresponseFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

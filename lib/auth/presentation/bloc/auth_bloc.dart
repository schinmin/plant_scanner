import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:plant_scanner_app/auth/domain/entity/user_entity.dart';
import 'package:plant_scanner_app/auth/domain/usecase/auth_usecase.dart';
import 'package:plant_scanner_app/core/error/failure.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUsecase authUsecase;
  AuthBloc(this.authUsecase) : super(AuthInitial()) {
    on<RegisterRequest>(_onRegisterRequest);
    on<LoginRequest>(_onLoginRequest);
  }

  ///Register
  Future<void> _onRegisterRequest(
    RegisterRequest event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final result = await authUsecase.register(
        event.name,
        event.phone,
        event.password,
        event.fcmToken,
      );

      result.fold(
        (failure) => emit(AuthError(Failure("Error :$failure"))),
        (user) => emit(AuthRegisterSuccess(user)),
      );
    } catch (e) {
      emit(AuthError(Failure("Error : ${e.toString()}")));
    }
  }

  ///Login Event
  ///
  Future<void> _onLoginRequest(
    LoginRequest event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final result = await authUsecase.login(
        event.phone,
        event.password,
        event.fcmToken,
      );

      result.fold(
        (failure) => emit(AuthError(failure)),
        (user) => emit(AuthLoginSuccess(user)),
      );
    } catch (e) {
      emit(AuthError(Failure(" Error : ${e.toString()}")));
    }
  }
}

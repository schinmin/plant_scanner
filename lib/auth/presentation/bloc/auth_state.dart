part of 'auth_bloc.dart';

@immutable
sealed class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {
  AuthLoading();
}

final class AuthRegisterSuccess extends AuthState {
  final UserEntity user;

  AuthRegisterSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

final class AuthLoginSuccess extends AuthState {
  final UserEntity user;
  AuthLoginSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

final class AuthError extends AuthState {
  final Failure failure;

  AuthError(this.failure);

  @override
  List<Object?> get props => [failure];
}

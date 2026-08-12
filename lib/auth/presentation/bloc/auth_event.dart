part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegisterRequest extends AuthEvent {
  final String name;
  final String phone;
  final String password;
  String? fcmToken;

  RegisterRequest({
    required this.name,
    required this.phone,
    required this.password,
    this.fcmToken,
  });

  @override
  List<Object?> get props => [name, phone, password, fcmToken];
}

class LoginRequest extends AuthEvent {
  final String phone;
  final String password;
  String? fcmToken;

  LoginRequest({required this.phone, required this.password, this.fcmToken});

  @override
  List<Object?> get props => [phone, password, fcmToken];
}

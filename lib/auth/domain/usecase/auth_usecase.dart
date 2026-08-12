import 'package:dartz/dartz.dart';
import 'package:plant_scanner_app/auth/domain/entity/user_entity.dart';
import 'package:plant_scanner_app/auth/domain/repository/auth_repository.dart';
import 'package:plant_scanner_app/core/error/failure.dart';

class AuthUsecase {
  final AuthRepository authRepository;

  const AuthUsecase(this.authRepository);

  Future<Either<Failure, UserEntity>> login(
    String phone,
    String password,
    String? fcmTokem,
  ) {
    return authRepository.login(
      phone: phone,
      password: password,
      fcmToken: fcmTokem,
    );
  }

  Future<Either<Failure, UserEntity>> register(
    String name,
    String phone,
    String password,
    String? fcmToken,
  ) {
    return authRepository.register(
      name: name,
      phone: phone,
      password: password,
      fcmToken: fcmToken,
    );
  }
}

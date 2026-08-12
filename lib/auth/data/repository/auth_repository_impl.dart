import 'package:dartz/dartz.dart';
import 'package:plant_scanner_app/auth/data/datasources/auth_datasources.dart';
import 'package:plant_scanner_app/auth/domain/entity/user_entity.dart';
import 'package:plant_scanner_app/auth/domain/repository/auth_repository.dart';
import 'package:plant_scanner_app/core/error/failure.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasources authDatasources;

  AuthRepositoryImpl(this.authDatasources);

  @override
  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String phone,
    required String password,
    String? fcmToken,
  }) async {
    final result = await authDatasources.register(
      name: name,
      phone: phone,
      password: password,
      fcmToken: fcmToken,
    );

    return result.fold(
      (failure) => Left(Failure("Error :$failure")),
      (user) => Right(user),
    );
  }

  @override
  Future<Either<Failure, UserEntity>> login({
    required String phone,
    required String password,
    String? fcmToken,
  }) async {
    final result = await authDatasources.login(
      phone: phone,
      password: password,
      fcmToken: fcmToken,
    );

    return result.fold(
      (failure) => Left(Failure("Error :$failure")),
      (user) => Right(user as UserEntity),
    );
  }
}

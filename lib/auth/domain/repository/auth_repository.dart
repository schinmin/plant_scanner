import 'package:dartz/dartz.dart';
import 'package:plant_scanner_app/auth/domain/entity/user_entity.dart';
import 'package:plant_scanner_app/core/error/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String phone,
    required String password,
    String? fcmToken,
  });
  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String phone,
    required String password,
    String? fcmToken,
  });
}

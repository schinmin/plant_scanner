import 'package:dartz/dartz.dart';
import 'package:plant_scanner_app/auth/data/models/user_model.dart';
import 'package:plant_scanner_app/core/database/shared_prefercences.dart';
import 'package:plant_scanner_app/core/error/failure.dart';
import 'package:plant_scanner_app/core/network/api_service.dart';

abstract class AuthDatasources {
  Future<Either<Failure, UserModel>> login({
    required String phone,
    required String password,
    String? fcmToken,
  });
  Future<Either<Failure, UserModel>> register({
    required String name,
    required String phone,
    required String password,
    String? fcmToken,
  });
}

class AuthDatasourcesImpl implements AuthDatasources {
  final ApiService apiService;

  const AuthDatasourcesImpl(this.apiService);

  @override
  Future<Either<Failure, UserModel>> login({
    required String phone,
    required String password,
    String? fcmToken,
  }) async {
    try {
      final fcmTokenFromDevice = await localStorageService.getFcmToken();
      final response = await apiService.dio.post(
        "login",
        data: {
          "phone": phone,
          "password": password,
          "fcm_token": fcmTokenFromDevice,
        },
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        final userResponse = response.data["user"];

        final user = UserModel.fromJson(userResponse);

        if (response.data['token'] != null) {
          final token = response.data['token'];
          await localStorageService.saveToken(token);
        }

        return Right(user);
      }
      return Left(Failure("Error : ${response.data['message']}"));
    } catch (e) {
      return Left(Failure("Error : ${e.toString()}"));
    }
  }

  @override
  Future<Either<Failure, UserModel>> register({
    required String name,
    required String phone,
    required String password,
    String? fcmToken,
  }) async {
    try {
      final response = await apiService.dio.post(
        "register",
        data: {
          "name": name,
          "phone": phone,
          "password": password,
          "fcm_token": fcmToken,
        },
      );
      if (response.statusCode == 201) {
        final userRsponse = response.data['user'];

        if (response.data['token'] != null) {
          final token = response.data['token'];
          await localStorageService.saveToken(token);
        }

        final user = UserModel.fromJson(userRsponse);

        return Right(user);
      }
      return Left(Failure("Error : ${response.data['message']}"));
    } catch (e) {
      return Left(Failure("Error : ${e.toString()}"));
    }
  }
}

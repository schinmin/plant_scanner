import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:plant_scanner_app/core/error/failure.dart';
import 'package:plant_scanner_app/pesticide_scan/data/datasources/pesticide_datasourecs.dart';
import 'package:plant_scanner_app/pesticide_scan/domain/entity/pesticide_entity.dart';
import 'package:plant_scanner_app/pesticide_scan/domain/repository/pesticide_repository.dart';

class PesticideRepositoryImpl implements PesticideRepository {
  final PesticideRemoteDatasource remoteDatasource;

  PesticideRepositoryImpl(this.remoteDatasource);

  @override
  Future<Either<Failure, PesticideScanResult>> scanPesticide(
    File imageFile,
  ) async {
    try {
      final result = await remoteDatasource.scanPesticide(imageFile);
      return Right(result);
    } on DioException catch (e) {
      final errorMsg =
          e.response?.data['message'] ?? e.message ?? "Server Error occurred";
      return Left(Failure(errorMsg));
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}

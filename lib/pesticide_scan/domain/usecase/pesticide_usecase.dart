import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:plant_scanner_app/core/error/failure.dart';
import 'package:plant_scanner_app/pesticide_scan/domain/entity/pesticide_entity.dart';
import 'package:plant_scanner_app/pesticide_scan/domain/repository/pesticide_repository.dart';

class ScanPesticideUseCase {
  final PesticideRepository repository;

  ScanPesticideUseCase(this.repository);

  Future<Either<Failure, PesticideScanResult>> call(File imageFile) async {
    return await repository.scanPesticide(imageFile);
  }
}

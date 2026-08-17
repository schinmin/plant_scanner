import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:plant_scanner_app/core/error/failure.dart';
import 'package:plant_scanner_app/pesticide_scan/domain/entity/pesticide_entity.dart';

abstract class PesticideRepository {
  Future<Either<Failure, PesticideScanResult>> scanPesticide(File imageFile);
}

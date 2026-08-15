import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:plant_scanner_app/core/constant/api_constant.dart';
import 'package:plant_scanner_app/core/database/shared_prefercences.dart';
import 'package:plant_scanner_app/core/error/failure.dart';
import 'package:plant_scanner_app/core/network/api_service.dart';
import 'package:plant_scanner_app/plant_simulation/data/models/farm_simulation_model.dart';

abstract class SimulationDatasources {
  Future<Either<Failure, FarmSimulationModel>> createSimulation({
    required String farmName,
    required String plantType,
    required String plantArea,
    required String soilType,
    required String plantingDate,
    required String season,
    required String location,
  });

  Future<Either<Failure, List<FarmSimulationModel>>> getSimulation();
}

class SimulationDataSourceImpl implements SimulationDatasources {
  final ApiService apiService;

  SimulationDataSourceImpl(this.apiService);

  @override
  Future<Either<Failure, FarmSimulationModel>> createSimulation({
    required String farmName,
    required String plantType,
    required String plantArea,
    required String soilType,
    required String plantingDate,
    required String location,
    required String season,
  }) async {
    try {
      final token = await localStorageService.getFcmToken();
      final farmAreaValue = double.tryParse(plantArea.replaceAll(',', '').trim());
      final normalizedDate = _normalizePlantingDate(plantingDate);

      if (farmAreaValue == null || farmAreaValue <= 0) {
        return Left(Failure('Invalid farm area'));
      }

      final data = <String, dynamic>{
        'farm_name': farmName,
        'plant_type': plantType,
        'soil_type': soilType,
        'season': season,
        'farm_area': farmAreaValue,
        'planting_date': normalizedDate,
        'location': location,
      };

      if (token != null && token.isNotEmpty) {
        data['device_token'] = token;
      }

      debugPrint('========== SIMULATION REQUEST ==========');
      debugPrint('DATA: $data');

      final response = await apiService.dio.post(
        createSimulationEndPoint,
        data: data,
      );

      debugPrint('========== SIMULATION RESPONSE ==========');
      debugPrint('STATUS CODE: ${response.statusCode}');
      debugPrint('DATA: ${response.data}');

      if (response.data['success'] == true) {
        final responseSimulation = response.data['data'];
        final simulation = FarmSimulationModel.fromJson(
          responseSimulation as Map<String, dynamic>,
        );
        return Right(simulation);
      }

      final message = response.data['message']?.toString();
      return Left(Failure(message ?? 'Simulation request failed'));
    } on DioException catch (e, stackTrace) {
      debugPrint('========== DIO ERROR ==========');
      debugPrint('TYPE: ${e.type}');
      debugPrint('MESSAGE: ${e.message}');
      debugPrint('STATUS: ${e.response?.statusCode}');
      debugPrint('RESPONSE: ${e.response?.data}');
      debugPrint('STACKTRACE: $stackTrace');

      return Left(
        Failure(
          e.response?.data?['message']?.toString() ??
              e.message ??
              'Network error',
        ),
      );
    } catch (e, stackTrace) {
      debugPrint('========== UNKNOWN ERROR ==========');
      debugPrint('ERROR: $e');
      debugPrint('STACKTRACE: $stackTrace');
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FarmSimulationModel>>> getSimulation() async {
    try {
      final response = await apiService.dio.get('simulation/user');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final result = response.data['data']['simulations'] as List<dynamic>;

        final simulations = result
            .map(
              (simulation) => FarmSimulationModel.fromJson(
                simulation as Map<String, dynamic>,
              ),
            )
            .toList();

        return Right(simulations);
      }

      return Left(
        Failure('Error Datasources : ${response.data['message']}'),
      );
    } catch (e, stackTrace) {
      debugPrint('Error ${e.toString()} StackTrace : ${stackTrace.toString()}');
      return Left(Failure('Error Data ${e.toString()}'));
    }
  }

  /// Accepts ISO strings, DateTime.toString(), or yyyy-MM-dd.
  String _normalizePlantingDate(String raw) {
    final trimmed = raw.trim();
    try {
      final parsed = DateTime.parse(trimmed);
      return DateFormat('yyyy-MM-dd').format(parsed.toLocal());
    } catch (_) {
      final match = RegExp(r'(\d{4}-\d{2}-\d{2})').firstMatch(trimmed);
      if (match != null) return match.group(1)!;
      return trimmed;
    }
  }
}

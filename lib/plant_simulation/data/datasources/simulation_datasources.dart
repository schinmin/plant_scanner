import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
  }) async {
    try {
      // farm_name,rice_type,soil_type,season,farm_area,planting_date,device_token}
      debugPrint('========== SIMULATION REQUEST ==========');

      debugPrint('farm_name: $farmName');
      debugPrint('plant_type: $plantType');
      debugPrint('soil_type: $soilType');
      debugPrint('plant_area: $plantArea');
      debugPrint('planting_date: $plantingDate');

      final response = await apiService.dio.post(
        'https://argitech-production.up.railway.app/api/simulation',
        data: {
          'farm_name': farmName,
          'plant_type': plantType,
          'soil_type': soilType,
          'season': "မိုးရာသီ",
          'farm_area': plantArea,
          'planting_date': plantingDate,
          'device_token': "abc",
        },
      );

      debugPrint('========== SIMULATION RESPONSE ==========');
      debugPrint('STATUS CODE: ${response.statusCode}');
      debugPrint('DATA: ${response.data}');

      if (response.data['success'] == true) {
        final responseSimulation = response.data['data'];

        debugPrint('========== PARSING MODEL ==========');
        debugPrint('DATA: $responseSimulation');

        final simulation = FarmSimulationModel.fromJson(responseSimulation);

        debugPrint('MODEL PARSED SUCCESSFULLY');

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
      debugPrint('URL: ${e.requestOptions.uri}');
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
      final response = await apiService.dio.get("simulation/user");

      if (response.statusCode == 200 && response.data['success'] == true) {
        final result = response.data['data']['simulations'] as List<dynamic>;

        final simulations = result
            .map((simulation) => FarmSimulationModel.fromJson(simulation))
            .toList();

        return Right(simulations);
      } else {
        return Left(Failure("Error Datasources : ${response.data['message']}"));
      }
    } catch (e, stackTrace) {
      debugPrint("Error ${e.toString()} StackTrace : ${stackTrace.toString()}");
      return Left(Failure("Error Data ${e.toString()}"));
    }
  }
}

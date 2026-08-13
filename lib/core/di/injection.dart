import 'package:dio/dio.dart';

import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
import 'package:plant_scanner_app/auth/data/datasources/auth_datasources.dart';
import 'package:plant_scanner_app/auth/data/repository/auth_repository_impl.dart';
import 'package:plant_scanner_app/auth/domain/repository/auth_repository.dart';
import 'package:plant_scanner_app/auth/domain/usecase/auth_usecase.dart';
import 'package:plant_scanner_app/auth/presentation/bloc/auth_bloc.dart';
import 'package:plant_scanner_app/core/network/api_service.dart';
import 'package:plant_scanner_app/plant_scan/data/datasources/get_crop_market_datasource.dart';
import 'package:plant_scanner_app/plant_scan/data/datasources/get_response_datasource.dart';
import 'package:plant_scanner_app/plant_scan/data/repository_imp/get_crop_market_repol_impl.dart';
import 'package:plant_scanner_app/plant_scan/data/repository_imp/get_disease_repol_impl.dart';
import 'package:plant_scanner_app/plant_scan/domain/repository/crop_market_repository.dart';
import 'package:plant_scanner_app/plant_scan/domain/repository/disease_repository.dart';
import 'package:plant_scanner_app/plant_scan/domain/usecase/get_crop_market_usecase.dart';
import 'package:plant_scanner_app/plant_scan/domain/usecase/get_disease_usecase.dart';
import 'package:plant_scanner_app/plant_scan/presentation/crop_prices/crop_prices_bloc.dart';
import 'package:plant_scanner_app/plant_scan/presentation/scan/bloc/getapiresponse_bloc.dart';
import 'package:plant_scanner_app/plant_simulation/data/datasources/simulation_datasources.dart';
import 'package:plant_scanner_app/plant_simulation/data/repository/simulation_repository_impl.dart';
import 'package:plant_scanner_app/plant_simulation/domain/repository/simulation_repository.dart';
import 'package:plant_scanner_app/plant_simulation/domain/usecase/simulation_usecase.dart';
import 'package:plant_scanner_app/plant_simulation/presentation/bloc/bloc/simulation_bloc.dart';

// import 'injection_modules.dart';

final GetIt sl = GetIt.instance;

/// Initialize dependency injection
Future<void> initDependencies() async {
  // Initialize core modules
  _initCoreModule();

  // Initialize feature modules
  _initAuthModule();
  _initPlantScanModule();
  _initPlantSimulationModule();

  // Remove splash screen
  FlutterNativeSplash.remove();
}

/// Core module (network, dio, etc.)
void _initCoreModule() {
  // Dio
  sl.registerLazySingleton<Dio>(() => Dio());

  // API Service
  sl.registerLazySingleton<ApiService>(() => ApiService());

  // Add interceptors if needed
  sl<Dio>().interceptors.addAll([
    LogInterceptor(
      request: true,
      requestBody: true,
      responseBody: true,
      error: true,
    ),
  ]);
}

/// Auth module
void _initAuthModule() {
  // Data Sources
  sl.registerLazySingleton<AuthDatasources>(
    () => AuthDatasourcesImpl(sl<ApiService>()),
  );
  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // Use Cases
  sl.registerLazySingleton<AuthUsecase>(() => AuthUsecase(sl()));
  // Blocs

  sl.registerFactory<AuthBloc>(() => AuthBloc(sl<AuthUsecase>()));
}

/// Plant Scan module
void _initPlantScanModule() {
  // Get Response
  _initGetResponseModule();

  // Crop Market
  _initCropMarketModule();
}

/// Get Response module
void _initGetResponseModule() {
  // Data Sources
  sl.registerLazySingleton<GetResponseDataSource>(
    () => GetResponseDataSourceImpl(sl<Dio>()),
  );

  // Repositories
  sl.registerLazySingleton<DiseaseRepository>(
    () => GetDiseaseRepolImpl(sl<GetResponseDataSource>()),
  );

  // Use Cases
  sl.registerLazySingleton<GetDiseaseUseCase>(
    () => GetDiseaseUseCase(sl<DiseaseRepository>()),
  );

  // Blocs
  sl.registerFactory<GetapiresponseBloc>(
    () => GetapiresponseBloc(sl<GetDiseaseUseCase>()),
  );
}

/// Crop Market module
void _initCropMarketModule() {
  // Data Sources
  sl.registerLazySingleton<GetCropMarketDatasource>(() => GetCropMarket(sl()));

  // Repositories
  sl.registerLazySingleton<CropMarketRepository>(
    () => GetCropMarketRepolImpl(sl<GetCropMarketDatasource>()),
  );

  // Use Cases
  sl.registerLazySingleton<GetCropMarketUseCase>(
    () => GetCropMarketUseCase(sl<CropMarketRepository>()),
  );

  // Blocs
  sl.registerFactory<CropPricesBloc>(
    () => CropPricesBloc(sl<GetCropMarketUseCase>()),
  );
}

/// Plant Simulation module
void _initPlantSimulationModule() {
  // Data Sources
  sl.registerLazySingleton<SimulationDatasources>(
    () => SimulationDataSourceImpl(sl<ApiService>()),
  );

  // Repositories
  sl.registerLazySingleton<SimulationRepository>(
    () => SimulationRepositoryImpl(sl<SimulationDatasources>()),
  );

  // Use Cases
  sl.registerLazySingleton<SimulationUsecase>(
    () => SimulationUsecase(sl<SimulationRepository>()),
  );

  // Blocs
  sl.registerFactory<SimulationBloc>(
    () => SimulationBloc(sl<SimulationUsecase>()),
  );
}

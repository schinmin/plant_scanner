import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get_it/get_it.dart';
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
import 'package:plant_scanner_app/plant_scan/presentation/pages/home.dart';

final sl = GetIt.instance;

void setup() {
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton<ApiService>(() => ApiService());
  sl.registerLazySingleton<GetResponseDataSource>(
    () => GetResponseDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<DiseaseRepository>(() => GetDiseaseRepolImpl(sl()));
  sl.registerLazySingleton(() => GetDiseaseRepolImpl(sl()));
  sl.registerLazySingleton(() => GetDiseaseUseCase(sl()));
  sl.registerFactory(() => GetapiresponseBloc(sl()));

  // Crop Market related registrations
  sl.registerLazySingleton<GetCropMarketDatasource>(() => GetCropMarket(sl()));
  sl.registerLazySingleton<CropMarketRepository>(
    () => GetCropMarketRepolImpl(sl()),
  );
  sl.registerLazySingleton<GetCropMarketUseCase>(
    () => GetCropMarketUseCase(sl()),
  );
  sl.registerFactory(() => CropPricesBloc(sl()));
  FlutterNativeSplash.remove(); // Remove the splash screen after setup is complete
}

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  setup();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plant Scanner App',
      theme: ThemeData(primarySwatch: Colors.green),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<GetapiresponseBloc>(
            create: (context) => sl<GetapiresponseBloc>(),
          ),
          BlocProvider<CropPricesBloc>(
            create: (context) => sl<CropPricesBloc>(),
          ),
        ],
        child: const HomePage(),
      ),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:plant_scanner_app/auth/presentation/bloc/auth_bloc.dart';
import 'package:plant_scanner_app/auth/presentation/screens/splash_screen.dart';
import 'package:plant_scanner_app/core/di/injection.dart';
import 'package:plant_scanner_app/core/notifications/fcm_service.dart';
import 'package:plant_scanner_app/firebase_options.dart';

import 'package:plant_scanner_app/plant_scan/presentation/crop_prices/crop_prices_bloc.dart';
import 'package:plant_scanner_app/plant_scan/presentation/scan/bloc/getapiresponse_bloc.dart';

import 'package:plant_scanner_app/plant_simulation/presentation/bloc/bloc/simulation_bloc.dart';

// final sl = GetIt.instance;

// void setup() {
//   sl.registerLazySingleton(() => Dio());
//   sl.registerLazySingleton<ApiService>(() => ApiService());
//   sl.registerLazySingleton<GetResponseDataSource>(
//     () => GetResponseDataSourceImpl(sl()),
//   );
//   sl.registerLazySingleton<DiseaseRepository>(() => GetDiseaseRepolImpl(sl()));
//   sl.registerLazySingleton(() => GetDiseaseRepolImpl(sl()));
//   sl.registerLazySingleton(() => GetDiseaseUseCase(sl()));
//   sl.registerFactory(() => GetapiresponseBloc(sl()));

//   // Crop Market related registrations
//   sl.registerLazySingleton<GetCropMarketDatasource>(() => GetCropMarket(sl()));
//   sl.registerLazySingleton<CropMarketRepository>(
//     () => GetCropMarketRepolImpl(sl()),
//   );
//   sl.registerLazySingleton<GetCropMarketUseCase>(
//     () => GetCropMarketUseCase(sl()),
//   );
//   sl.registerFactory(() => CropPricesBloc(sl()));

//   // Simulation
//   sl.registerLazySingleton<SimulationDatasources>(
//     () => SimulationDataSourceImpl(sl()),
//   );

//   sl.registerLazySingleton(() => SimulationDataSourceImpl(sl()));

//   sl.registerLazySingleton<SimulationRepository>(
//     () => SimulationRepositoryImpl(sl()),
//   );
//   sl.registerLazySingleton<SimulationUsecase>(() => SimulationUsecase(sl()));

//   sl.registerFactory<SimulationBloc>(() => SimulationBloc(sl()));

//   //Auth
//   FlutterNativeSplash.remove(); // Remove the splash screen after setup is complete
// }

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final fcmService = FCMService();
  final token = await fcmService.initialize();
  debugPrint("Main FCM TOKEN : ${token.toString()}");
  await initDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => sl<AuthBloc>()),
        BlocProvider<SimulationBloc>(create: (context) => sl<SimulationBloc>()),
        BlocProvider<GetapiresponseBloc>(
          create: (context) => sl<GetapiresponseBloc>(),
        ),
        BlocProvider<CropPricesBloc>(create: (context) => sl<CropPricesBloc>()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Plant Scanner App',
        home: SplashScreen(),
      ),
    );
  }
}

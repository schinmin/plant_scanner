import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:plant_scanner_app/auth/presentation/bloc/auth_bloc.dart';
import 'package:plant_scanner_app/auth/presentation/screens/splash_screen.dart';
import 'package:plant_scanner_app/core/di/injection.dart';
import 'package:plant_scanner_app/core/notifications/fcm_service.dart';
import 'package:plant_scanner_app/core/notifications/local_notification_service.dart';
import 'package:plant_scanner_app/firebase_options.dart';
import 'package:plant_scanner_app/pesticide_scan/presentation/bloc/pesticide_bloc.dart';

import 'package:plant_scanner_app/plant_scan/presentation/crop_prices/crop_prices_bloc.dart';
import 'package:plant_scanner_app/plant_scan/presentation/scan/bloc/getapiresponse_bloc.dart';

import 'package:plant_scanner_app/plant_simulation/presentation/bloc/bloc/simulation_bloc.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final fcmService = FCMService();
  final token = await fcmService.initialize();
  debugPrint('Main FCM TOKEN : $token');

  // Single plugin instance — do not initialize FlutterLocalNotificationsPlugin again.
  final notificationService = NotificationService();
  await notificationService.initNotification();
  //await notificationService.showTestNotification();

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
        BlocProvider<PesticideBloc>(create: (context) => sl<PesticideBloc>()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Plant Scanner App',
        home: SplashScreen(),
      ),
    );
  }
}

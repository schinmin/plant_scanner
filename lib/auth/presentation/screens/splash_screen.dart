import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:plant_scanner_app/auth/presentation/screens/register_screen.dart';
import 'package:plant_scanner_app/core/database/shared_prefercences.dart';
import 'package:plant_scanner_app/core/di/injection.dart';
import 'package:plant_scanner_app/plant_scan/presentation/pages/main_home.dart';
import 'package:plant_scanner_app/plant_simulation/presentation/bloc/bloc/simulation_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // ✅ Initialize animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    // ✅ Start animation
    _animationController.forward();

    // ✅ Navigate to next screen
    _navigateToNextScreen();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _navigateToNextScreen() async {
    // ✅ Wait for splash to show
    await Future.delayed(const Duration(milliseconds: 2000));

    // ✅ Remove native splash
    FlutterNativeSplash.remove();

    try {
      // ✅ Check if user is logged in
      final token = await localStorageService.getUserToken();

      if (token != null && token.isNotEmpty) {
        // ✅ User is logged in - go to main home
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => sl<SimulationBloc>(),
                child: const MainHome(),
              ),
            ),
            (route) => false,
          );
        }
      } else {
        // ✅ User is not logged in - go to register
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const RegisterPage()),
          );
        }
      }
    } catch (_) {
      // ✅ Error occurred - go to register
      debugPrint('SplashScreen could not restore the user session');
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const RegisterPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2E7D32), // Dark green
              Color(0xFF4CAF50), // Green
              Color(0xFF66BB6A), // Light green
            ],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo Container
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(Icons.eco, color: Colors.green, size: 80),
                    ),
                  ),
                  const SizedBox(height: 35),

                  // App Name
                  const Text(
                    'AI Alert',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  const Text(
                    'စိုက်ပျိုးရေး',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 45),

                  // Loading Indicator
                  const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 16),

                  // Loading Text
                  const Text(
                    'စတင်နေပါပြီ...',
                    style: TextStyle(color: Colors.white60, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

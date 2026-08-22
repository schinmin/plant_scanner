import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:plant_scanner_app/core/theme/app_theme.dart';
import 'package:plant_scanner_app/notifications/notifications_screen.dart';

import 'package:plant_scanner_app/plant_scan/presentation/pages/welther_screen.dart';
import 'package:plant_scanner_app/plant_scan/presentation/widgets/drawer.dart';
import 'package:plant_scanner_app/plant_simulation/presentation/screens/my_simulations.dart';
import 'package:plant_scanner_app/plant_simulation/presentation/screens/simulation_screen.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = [
    WeltherScreen(),
    SimulationScreen(),
    MySimulationsScreen(isChild: false),
    // SettingsScreen(),

    // MySimulationsScreen(),
    // LeafScanner(),
    // CropMarketScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ProfileDrawer(isLoggedIn: true, onAuthToggle: () {}),
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 40,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.eco, color: Colors.green, size: 20),
            ),
            const Text(
              'Smart Farm Simulation',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(Icons.notification_add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationListScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: _widgetOptions),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withValues(alpha: 0.08),
            ),
          ],
        ),

        child: Padding(
          padding: const EdgeInsets.all(8),

          child: GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            gap: 8,
            activeColor: AppColors.primary,
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: Colors.grey[100]!,
            color: Colors.black54,
            tabs: const [
              GButton(icon: Icons.home, text: "Home"),
              GButton(icon: Icons.area_chart, text: ""),
              GButton(icon: Icons.person, text: ""),
              // GButton(icon: Icons.settings, text: ""),
              // GButton(icon: Icons.scanner, text: ""),
              // GButton(icon: Icons.price_change, text: ""),
            ],

            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}

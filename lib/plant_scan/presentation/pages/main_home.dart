import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:plant_scanner_app/bottom_nav_screens/settings.dart';
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
    MySimulationsScreen(),
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
        backgroundColor: Colors.green.shade700,
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
      body: _widgetOptions.elementAt(_selectedIndex),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(1)),
          ],
        ),

        child: Padding(
          padding: EdgeInsets.all(8),

          child: GNav(
            rippleColor: Colors.grey[300]!,
            hoverColor: Colors.grey[100]!,
            gap: 8,
            activeColor: Colors.black,
            iconSize: 24,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            duration: Duration(milliseconds: 400),
            tabBackgroundColor: Colors.grey[100]!,
            color: Colors.black,
            tabs: [
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

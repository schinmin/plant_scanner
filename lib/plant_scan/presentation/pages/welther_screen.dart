import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:plant_scanner_app/core/network/api_service.dart';
import 'package:plant_scanner_app/pesticide_scan/presentation/pages/pesticide_scan_page.dart';
import 'package:plant_scanner_app/plant_scan/presentation/pages/crop_market_screen.dart';
import 'package:plant_scanner_app/plant_scan/presentation/pages/leaf_scanner.dart';
import 'package:plant_scanner_app/plant_simulation/presentation/screens/my_simulations.dart';
import 'package:plant_scanner_app/plant_simulation/presentation/screens/simulation_screen.dart';
import 'package:plant_scanner_app/rice_variety/rice_variety_screen.dart';
import 'package:plant_scanner_app/soil_variety/soil_list_screen.dart';

class WeltherScreen extends StatefulWidget {
  const WeltherScreen({super.key});

  @override
  State<WeltherScreen> createState() => _WeltherScreenState();
}

class _WeltherScreenState extends State<WeltherScreen> {
  late ApiService apiService;
  // မြန်မာပြည်နယ်နှင့် တိုင်း မြို့တော်စာရင်း (API မှာ အလုပ်လုပ်နိုင်တဲ့ မြို့အမည်များ)
  final List<String> myanmarCities = [
    'Yangon',
    'Mandalay',
    'Naypyidaw',
    'Sittwe',
    'Pathein',
    'Taunggyi',
    'Myitkyina',
    'Hakha',
    'Mawlamyine',
    'Bago',
    'Magway',
    'Loikaw',
    'Kengtung',
    'Dawei',
  ];

  // Display Name များ (Dropdown မှာ မြန်မာလို ပြဖို့)
  final Map<String, String> cityDisplayNames = {
    'Yangon': 'ရန်ကုန်တိုင်း',
    'Mandalay': 'မန္တလေးတိုင်း',
    'Naypyidaw': 'နေပြည်တော်',
    'Sittwe': 'ရခိုင်ပြည်နယ်',
    'Pathein': 'ဧရာဝတီတိုင်း',
    'Taunggyi': 'ရှမ်းပြည်နယ်',
    'Myitkyina': 'ကချင်ပြည်နယ်',
    'Meiktila': "မိတ္ထီလာ",
    'Hakha': 'ချင်းပြည်နယ်',
    'Mawlamyine': 'မွန်ပြည်နယ်',
    'Bago': 'ပဲခူးတိုင်း',
    'Magway': 'မကွေးတိုင်း',
    'Loikaw': 'ကယားပြည်နယ်',
    'Kengtung': 'ရှမ်းပြည်နယ်(အရှေ့)',
    'Dawei': 'တနင်္သာရီတိုင်း',
  };

  String selectedCity = 'Yangon'; // Default city
  Map<String, dynamic> weatherData = {
    'temp': 31,
    'humidity': 60,
    'city': 'Yangon',
    'condition': 'Sunny',
  };
  bool isLoadingWeather = false;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    _fetchWeather(selectedCity);
  }

  // --- Weather API Integration with City Parameter ---
  Future<void> _fetchWeather(String city) async {
    setState(() {
      isLoadingWeather = true;
    });

    // ဒီနေရာမှာ ခင်ဗျားရဲ့ OpenWeatherMap API Key ထည့်ပေးပါ။
    const String apiKey = '5fad1b7021471f4e8875faf83e33c2e4';
    final String url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$apiKey';

    try {
      final response = await apiService.dio.get(url);

      if (response.statusCode == 200) {
        final data = response.data;
        debugPrint("Welther Data $data");
        setState(() {
          weatherData = {
            'temp': (data['main']['temp'] as double).round(),
            'humidity': data['main']['humidity'],
            'city': data['name'],
            'condition': data['weather'][0]['main'],
          };
          isLoadingWeather = false;
        });
      } else {
        setState(() {
          isLoadingWeather = false;
        });
        debugPrint('Failed to load weather: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoadingWeather = false;
      });
      debugPrint('Error fetching weather: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Header & Weather
              _buildHeader(),
              const SizedBox(height: 24),

              // 2. Quick Access Title
              const Text(
                'လုပ်ဆောင်ချက်များ',
                style: TextStyle(
                  color: Color(0xFF2E7D32),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // const SimulationScreen(),

              // 3. Quick Access Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: [
                  _buildQuickAccessCard(
                    title: 'စမ်းသပ်စိုက်ပျိုးခြင်း',
                    icon: Icons.track_changes,
                    badge: 'Simulation',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SimulationScreen(),
                        ),
                      );
                    },
                  ),

                  _buildQuickAccessCard(
                    title: 'သင်၏စိုက်ခင်းများ',
                    icon: Icons.layers_outlined,
                    badge: null,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MySimulationsScreen(),
                        ),
                      );
                    },
                  ),
                  _buildQuickAccessCard(
                    title: 'အပင်၏ရောဂါရှာဖွေစစ်ဆေးခြင်း',
                    icon: Icons.bug_report_outlined,
                    badge: 'AI SCAN',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LeafScanner()),
                      );
                    },
                  ),
                  _buildQuickAccessCard(
                    title: 'ပိုးသတ်ဆေးများကို စစ်ဆေးခြင်း',
                    icon: Icons.bug_report_outlined,
                    badge: 'AI SCAN',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PesticideScanPage(),
                        ),
                      );
                    },
                  ),
                  _buildQuickAccessCard(
                    title: 'သီးနှံဈေးနှုန်းများ',
                    icon: Icons.show_chart,
                    badge: null,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CropMarketScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 4. Farming Knowledge Title
              const Text(
                'အသိပညာပေးခြင်း',
                style: TextStyle(
                  color: Color(0xFF2E7D32),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // 5. Farming Knowledge Grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.2,
                children: [
                  _buildKnowledgeCard(
                    title: 'ဆန်အမျိုးအစားများ',
                    icon: Icons.grass,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RiceSphereApp(),
                        ),
                      );
                    },
                  ),
                  _buildKnowledgeCard(
                    title: 'မြေအမျိုးအစားများ',
                    icon: Icons.terrain_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SoilListPage()),
                      );
                    },
                  ),
                  _buildKnowledgeCard(
                    title: 'ပိုးမွှားနှင့် ရောဂါများ',
                    icon: Icons.bug_report,
                    onTap: () {},
                  ),
                  _buildKnowledgeCard(
                    title: 'ကျွမ်းကျင်ပညာရှင်များ',
                    icon: Icons.person_outline,
                    onTap: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   backgroundColor: const Color(0xFF2E7D32),
      //   child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
      // ),
    );
  }

  // --- Header Widget (Including Dropdown) ---

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: () => _showCityPickerBottomSheet(context),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey.withOpacity(0.12)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left Side: Location Info
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.location_on_rounded,
                      color: Colors.green[700],
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'လက်ရှိဒေသ',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            cityDisplayNames[selectedCity] ?? selectedCity,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 18,
                            color: Colors.grey[600],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              // Vertical Divider
              Container(height: 28, width: 1, color: Colors.grey[200]),

              // Right Side: Weather Details
              if (isLoadingWeather)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                )
              else
                Row(
                  children: [
                    Icon(
                      _getWeatherIcon(weatherData['condition']),
                      size: 22,
                      color: _getWeatherIconColor(weatherData['condition']),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${weatherData['temp']}°C',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.water_drop_rounded,
                              size: 10,
                              color: Colors.blue[600],
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${weatherData['humidity']}%',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  // 🏙️ Card နှိပ်လိုက်လျှင် မြို့ရွေးရန် ပွင့်လာမည့် Bottom Sheet Modal
  void _showCityPickerBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'မြို့နယ် ရွေးချယ်ပါ',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: myanmarCities.length,
                  itemBuilder: (context, index) {
                    final cityKey = myanmarCities[index];
                    final cityName = cityDisplayNames[cityKey] ?? cityKey;
                    final isSelected = selectedCity == cityKey;

                    return ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      selected: isSelected,
                      selectedTileColor: Colors.green[50],
                      title: Text(
                        cityName,
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? Colors.green[800]
                              : Colors.black87,
                        ),
                      ),
                      trailing: isSelected
                          ? Icon(Icons.check_circle, color: Colors.green[700])
                          : null,
                      onTap: () {
                        setState(() {
                          selectedCity = cityKey;
                        });
                        _fetchWeather(cityKey);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 💡 Weather Icon & Color Helpers
  IconData _getWeatherIcon(String? condition) {
    switch (condition?.toLowerCase()) {
      case 'sunny':
      case 'clear':
        return Icons.wb_sunny_rounded;
      case 'rainy':
      case 'rain':
        return Icons.thunderstorm_rounded;
      case 'cloudy':
      case 'clouds':
        return Icons.cloud_rounded;
      default:
        return Icons.wb_cloudy_rounded;
    }
  }

  Color _getWeatherIconColor(String? condition) {
    switch (condition?.toLowerCase()) {
      case 'sunny':
      case 'clear':
        return Colors.amber[700]!;
      case 'rainy':
      case 'rain':
        return Colors.blue[600]!;
      case 'cloudy':
      case 'clouds':
        return Colors.grey[600]!;
      default:
        return Colors.orangeAccent;
    }
  }

  // 💡 Weather Condition အလိုက် Icon နှင့် Color ပြောင်းပေးမည့် Helper Functions

  Widget _buildQuickAccessCard({
    required String title,
    required IconData icon,
    String? badge,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, size: 32, color: Colors.green),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            if (badge != null)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB39DDB),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Icon(
                Icons.arrow_forward,
                size: 16,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKnowledgeCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, size: 32, color: Colors.green[700]),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Icon(
                Icons.arrow_forward,
                size: 16,
                color: Colors.grey[300],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

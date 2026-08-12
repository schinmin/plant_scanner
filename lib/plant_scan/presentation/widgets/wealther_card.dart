import 'package:flutter/material.dart';
import 'package:plant_scanner_app/plant_scan/data/models/wealther_model.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;

  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    // final textColor = weather.isDayTime ? Colors.white : Colors.white70;

    return Card(
      elevation: 16,
      shadowColor: Colors.black45,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Stack(
          children: [
            // 🖼️ နောက်ခံပုံ (Background Image)
            Positioned.fill(
              child: Image.asset(
                'assets/images/splash/weather_bg.jpg',
                fit: BoxFit.cover,
              ),
            ),

            // 🌈 Gradient Overlay (စာတွေ ပေါ်လွင်အောင်)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.2), // အပေါ်ပိုင်း မှိန်မှိန်
                      Colors.black.withOpacity(0.6), // အောက်ပိုင်း ပိုမည်း
                    ],
                  ),
                ),
              ),
            ),

            // 📝 စာသားတွေ (Text Content)
            Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 📍 ထိပ်ပိုင်း - မြို့အမည်နဲ့ ရာသီဥတု
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_pin,
                            size: 22,
                            color: Colors.redAccent,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            weather.cityName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              shadows: [
                                Shadow(blurRadius: 8, color: Colors.black45),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          weather.condition,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // ☀️ အလယ်ပိုင်း - အိုင်ကွန်နဲ့ အပူချိန်
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        weather.icon,
                        style: const TextStyle(
                          fontSize: 64,
                          shadows: [
                            Shadow(blurRadius: 12, color: Colors.black38),
                          ],
                        ),
                      ),
                      const SizedBox(width: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${weather.temperature.round()}°C',
                            style: const TextStyle(
                              fontSize: 52,
                              fontWeight: FontWeight.bold,
                              height: 0.9,
                              color: Colors.white,
                              letterSpacing: -1,
                              shadows: [
                                Shadow(blurRadius: 10, color: Colors.black45),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              _buildTempChip('↑ ${weather.maxTemp.round()}°'),
                              const SizedBox(width: 10),
                              _buildTempChip('↓ ${weather.minTemp.round()}°'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ➖ မျဉ်းခြား
                  Divider(
                    color: Colors.white.withOpacity(0.25),
                    thickness: 1.5,
                  ),

                  const SizedBox(height: 12),

                  // 💨 အောက်ခြေ - အသေးစိတ် အချက်အလက်များ
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildDetailColumn(
                        icon: Icons.air,
                        label: 'လေတိုက်နှုန်း',
                        value: '${weather.windSpeed} km/h',
                      ),
                      _buildDetailColumn(
                        icon: Icons.water_drop,
                        label: 'စိုထိုင်းဆ',
                        value: '${weather.humidity}%',
                      ),
                      _buildDetailColumn(
                        icon: Icons.wb_sunny_outlined,
                        label: 'နေထွက်/ဝင်',
                        value: '${weather.sunrise}/${weather.sunset}',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper: အပူချိန် Chip
  Widget _buildTempChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  // Helper: အသေးစိတ် Column
  Widget _buildDetailColumn({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.white.withOpacity(0.9)),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withOpacity(0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

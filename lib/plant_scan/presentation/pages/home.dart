import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:plant_scanner_app/plant_scan/data/models/wealther_model.dart';
import 'package:plant_scanner_app/plant_scan/presentation/widgets/wealther_card.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final swiperCards = [
      CustomCard("Yangon"),
      CustomCard("Mandalay"),
      CustomCard("Pyi Oo Lwin"),
    ];
    // 🌦️ Weather Data List (မြို့အလိုက်)
    final List<Weather> weatherList = [
      Weather(
        cityName: 'ရန်ကုန်',
        temperature: 32,
        maxTemp: 35,
        minTemp: 27,
        humidity: 78,
        windSpeed: 12,
        condition: 'နေသာ',
        icon: '☀️',
        sunrise: '၀၅:၄၅',
        sunset: '၁၈:၃၀',
        isDayTime: true,
      ),
      Weather(
        cityName: 'မန္တလေး',
        temperature: 38,
        maxTemp: 41,
        minTemp: 30,
        humidity: 45,
        windSpeed: 8,
        condition: 'ပူပြင်း',
        icon: '🔥',
        sunrise: '၀၅:၃၀',
        sunset: '၁၈:၄၅',
        isDayTime: true,
      ),
      Weather(
        cityName: 'နေပြည်တော်',
        temperature: 30,
        maxTemp: 33,
        minTemp: 24,
        humidity: 70,
        windSpeed: 10,
        condition: 'တိမ်ထူ',
        icon: '⛅',
        sunrise: '၀၅:၅၀',
        sunset: '၁၈:၂၀',
        isDayTime: true,
      ),
      Weather(
        cityName: 'ပြင်ဦးလွင်',
        temperature: 20,
        maxTemp: 24,
        minTemp: 15,
        humidity: 85,
        windSpeed: 18,
        condition: 'အေးမြ',
        icon: '🌥️',
        sunrise: '၀၆:၁၀',
        sunset: '၁၈:၀၀',
        isDayTime: false, // ညအချိန်
      ),
    ];

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
          width: double.infinity,
          height: 310,

          child: Swiper(
            autoplay: true,
            itemCount: swiperCards.length,
            itemBuilder: (context, index) {
              return WeatherCard(weather: weatherList[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget CustomCard(String title) {
    return Card(child: Column(children: [Text(title)]));
  }
}

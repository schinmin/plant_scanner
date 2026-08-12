class Weather {
  final String cityName;
  final double temperature;
  final double maxTemp;
  final double minTemp;
  final int humidity;
  final double windSpeed;
  final String condition;
  final String icon;
  final String sunrise;
  final String sunset;
  final bool isDayTime; // နေ့/ည ခွဲခြားဖို့

  Weather({
    required this.cityName,
    required this.temperature,
    required this.maxTemp,
    required this.minTemp,
    required this.humidity,
    required this.windSpeed,
    required this.condition,
    required this.icon,
    required this.sunrise,
    required this.sunset,
    this.isDayTime = true,
  });
}

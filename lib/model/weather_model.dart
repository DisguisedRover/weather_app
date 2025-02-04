class WeatherInfo {
  final String cityName;
  final double temperature;
  final String description;
  final int humidity;
  final double windSpeed;
  final String icon;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int pressure;
  final DateTime sunrise;
  final DateTime sunset;

  WeatherInfo({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.icon,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.pressure,
    required this.sunrise,
    required this.sunset,
  });

  factory WeatherInfo.fromJson(Map<String, dynamic> json) {
    return WeatherInfo(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      icon: json['weather'][0]['icon'],
      feelsLike: json['main']['feels_like'].toDouble(),
      tempMin: json['main']['temp_min'].toDouble(),
      tempMax: json['main']['temp_max'].toDouble(),
      pressure: json['main']['pressure'],
      sunrise:
          DateTime.fromMillisecondsSinceEpoch(json['sys']['sunrise'] * 1000),
      sunset: DateTime.fromMillisecondsSinceEpoch(json['sys']['sunset'] * 1000),
    );
  }
}

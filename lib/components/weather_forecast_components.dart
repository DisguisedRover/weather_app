import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/weather_model.dart';

class WeatherForecast extends StatelessWidget {
  final List<WeatherInfo> forecast;

  const WeatherForecast({
    Key? key,
    required this.forecast,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          '5-Day Forecast',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: forecast.length,
            itemBuilder: (context, index) {
              return ForecastCard(
                weather: forecast[index],
                index: index,
              );
            },
          ),
        ),
      ],
    );
  }
}

class ForecastCard extends StatelessWidget {
  final WeatherInfo weather;
  final int index;

  const ForecastCard({
    Key? key,
    required this.weather,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 200 + (index * 100)),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                DateFormat('EEE').format(
                  DateTime.now().add(Duration(days: index)),
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Image.network(
                'https://openweathermap.org/img/w/${weather.icon}.png',
                scale: 1.5,
              ),
              Text(
                '${weather.temperature.round()}°C',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:weather_app/model/weather_model.dart';

class WeatherCard extends StatelessWidget {
  final WeatherInfo weather;
  final bool isDetailed;

  const WeatherCard({
    Key? key,
    required this.weather,
    this.isDetailed = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade300,
              Colors.blue.shade600,
            ],
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weather.cityName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      DateFormat('EEEE, MMMM d').format(DateTime.now()),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Image.network(
                  'https://openweathermap.org/img/w/${weather.icon}.png',
                  scale: 0.5,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${weather.temperature.round()}°C',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Feels like: ${weather.feelsLike.round()}°C',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    Text(
                      weather.description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (isDetailed) ...[
              const Divider(color: Colors.white30, height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDetailItem(
                    Icons.water_drop,
                    'Humidity',
                    '${weather.humidity}%',
                  ),
                  _buildDetailItem(
                    Icons.air,
                    'Wind',
                    '${weather.windSpeed} m/s',
                  ),
                  _buildDetailItem(
                    Icons.compress,
                    'Pressure',
                    '${weather.pressure} hPa',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDetailItem(
                    Icons.wb_sunny,
                    'Sunrise',
                    DateFormat('HH:mm').format(weather.sunrise),
                  ),
                  _buildDetailItem(
                    Icons.wb_twilight,
                    'Sunset',
                    DateFormat('HH:mm').format(weather.sunset),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

class WeatherAnimationController {
  late AnimationController fadeController;
  late Animation<double> fadeAnimation;
  final ValueNotifier<Color> backgroundColorNotifier =
      ValueNotifier(Colors.blue.shade700);

  WeatherAnimationController(TickerProvider vsync) {
    fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: vsync,
    );

    fadeAnimation = CurvedAnimation(
      parent: fadeController,
      curve: Curves.easeInOut,
    );

    fadeController.forward();
  }

  Color getWeatherColor(String description) {
    description = description.toLowerCase();
    if (description.contains('clear')) {
      return Colors.blue.shade600;
    } else if (description.contains('rain')) {
      return Colors.blueGrey.shade700;
    } else if (description.contains('cloud')) {
      return Colors.grey.shade600;
    } else if (description.contains('snow')) {
      return Colors.lightBlue.shade300;
    } else if (description.contains('thunder')) {
      return Colors.deepPurple.shade700;
    }
    return Colors.blue.shade700;
  }

  void updateBackgroundColor(String description) {
    final Color newColor = getWeatherColor(description);
    backgroundColorNotifier.value = newColor;
    fadeController.forward(from: 0.0);
  }

  void dispose() {
    fadeController.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:weather_app/components/weather_card.dart';
import 'package:weather_app/services/gps_service.dart';
import 'package:weather_app/services/weather_service.dart';

import '../components/weather_animation_controller.dart';
import '../components/weather_forecast_components.dart';
import '../components/weather_search_components.dart';
import '../model/weather_model.dart';

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _cityController = TextEditingController();
  WeatherInfo? _currentWeather;
  List<WeatherInfo>? _forecast;
  bool _isLoading = false;
  final WeatherService _weatherService = WeatherService();
  final GpsService _gpsService = GpsService();
  final List<String> _recentSearches = [];
  late WeatherAnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = WeatherAnimationController(this);
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);

    try {
      final position = await _gpsService.getCurrentLocation();
      if (position != null && mounted) {
        final weather = await _weatherService.fetchWeatherByCoords(
          position.latitude,
          position.longitude,
        );
        final forecast = await _weatherService.fetchForecastByCoords(
          position.latitude,
          position.longitude,
        );

        if (mounted) {
          setState(() {
            _currentWeather = weather;
            _forecast = forecast;
            _isLoading = false;
          });
          _animationController.updateBackgroundColor(weather.description);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showError('Location error', e.toString());
      }
    }
  }

  Future<void> _fetchWeather(String city) async {
    if (city.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final weather = await _weatherService.fetchWeather(city);
      final forecast = await _weatherService.fetchForecast(city);

      if (mounted) {
        setState(() {
          _currentWeather = weather;
          _forecast = forecast;
          _isLoading = false;
          _updateRecentSearches(city);
        });
        _animationController.updateBackgroundColor(weather.description);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _currentWeather = null;
          _forecast = null;
          _isLoading = false;
        });
        _showError('Weather fetch error', e.toString());
      }
    }
  }

  void _updateRecentSearches(String city) {
    if (!_recentSearches.contains(city)) {
      setState(() {
        _recentSearches.insert(0, city);
        if (_recentSearches.length > 5) _recentSearches.removeLast();
      });
    }
  }

  void _showError(String title, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(8),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(message),
          ],
        ),
        action: title == 'Location error'
            ? const SnackBarAction(
                label: 'Settings',
                onPressed: openAppSettings,
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: _animationController.backgroundColorNotifier,
      builder: (context, backgroundColor, child) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  backgroundColor,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildAppBar(),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WeatherSearch(
                          controller: _cityController,
                          onSubmitted: _fetchWeather,
                          onLocationPressed: _getCurrentLocation,
                        ),
                        RecentSearches(
                          searches: _recentSearches,
                          onSearchSelected: (city) {
                            _cityController.text = city;
                            _fetchWeather(city);
                          },
                        ),
                        _buildWeatherContent(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      floating: true,
      pinned: true,
      stretch: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withOpacity(0.7), Colors.transparent],
            ).createShader(rect);
          },
          blendMode: BlendMode.dstIn,
          child: Image.asset(
            'lib/assets/images/weather_background3.jpg',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherContent() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      );
    }

    if (_currentWeather == null) {
      return const SizedBox.shrink();
    }

    return FadeTransition(
      opacity: _animationController.fadeAnimation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          WeatherCard(
            weather: _currentWeather!,
            isDetailed: true,
          ),
          if (_forecast != null && _forecast!.isNotEmpty)
            WeatherForecast(forecast: _forecast!),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cityController.dispose();
    super.dispose();
  }
}

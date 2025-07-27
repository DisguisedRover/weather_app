import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/weather_state.dart';

import '../services/gps_service.dart';
import '../services/weather_service.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherService _weatherService;
  final GpsService _gpsService;
  final List<String> _recentSearches = [];

  WeatherCubit(this._weatherService, this._gpsService)
      : super(WeatherInitial());

  Future<void> fetchWeatherForCurrnetLocation() async {
    emit(WeatherLoading());
    try {
      final position = await _gpsService.getCurrentLocation();
      if (position != null) {
        final currentWeather = await _weatherService.fetchWeatherByCoords(
          position.latitude,
          position.longitude,
        );
        final forecast = await _weatherService.fetchForecastByCoords(
          position.latitude,
          position.longitude,
        );
        _updateRecentSearches(currentWeather.cityName);
        emit(WeatherLoaded(
          currentWeather: currentWeather,
          forecast: forecast,
          recentSearches: List.from(_recentSearches),
        ));
      } else {
        emit(const WeatherError('Could not get current location.',
            isLocationError: true));
      }
    } catch (e) {
      emit(WeatherError('Failed to fetch weather by location: ${e.toString()}',
          isLocationError: true));
    }
  }

  Future<void> fetchWeatherForCity(String city) async {
    if (city.isEmpty) return;

    emit(WeatherLoading());

    try {
      final currentWeather = await _weatherService.fetchWeather(city);
      final forecast = await _weatherService.fetchForecast(city);
      _updateRecentSearches(city);
      emit(WeatherLoaded(
        currentWeather: currentWeather,
        forecast: forecast,
        recentSearches: List.from(_recentSearches),
      ));
    } catch (e) {
      emit(WeatherError('Failed to fetch weather for $city: ${e.toString()}'));
    }
  }

  void _updateRecentSearches(String city) {
    if (!_recentSearches.contains(city)) {
      _recentSearches.insert(0, city);
      if (_recentSearches.length > 5) {
        _recentSearches.removeLast();
      }
    }
    if (state is WeatherLoaded) {
      emit((state as WeatherLoaded)
          .copyWith(recentSearches: List.from(_recentSearches)));
    }
  }

  void selectRecentSearch(String city) {
    fetchWeatherForCity(city);
  }
}

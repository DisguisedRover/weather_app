import 'package:equatable/equatable.dart';
import 'package:weather_app/model/weather_model.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final WeatherInfo currentWeather;
  final List<WeatherInfo> forecast;
  final List<String> recentSearches;

  const WeatherLoaded({
    required this.currentWeather,
    required this.forecast,
    this.recentSearches = const [],
  });

  @override
  List<Object?> get props => [currentWeather, forecast, recentSearches];

  WeatherLoaded copyWith({
    WeatherInfo? currentWeather,
    List<WeatherInfo>? forecast,
    List<String>? recentSearches,
  }) {
    return WeatherLoaded(
      currentWeather: currentWeather ?? this.currentWeather,
      forecast: forecast ?? this.forecast,
      recentSearches: recentSearches ?? this.recentSearches,
    );
  }
}

class WeatherError extends WeatherState {
  final String message;
  final bool isLocationError;

  const WeatherError(this.message, {this.isLocationError = false});

  @override
  List<Object> get props => [message, isLocationError];
}

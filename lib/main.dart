import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/weather_cubit.dart';
import 'package:weather_app/pages/homePage.dart';
import 'package:weather_app/services/gps_service.dart';
import 'package:weather_app/services/weather_service.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WeatherCubit>(
          create: (context) => WeatherCubit(WeatherService(), GpsService()),
        ),
      ],
      child: MaterialApp(
        title: 'Mausam',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const WeatherHomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

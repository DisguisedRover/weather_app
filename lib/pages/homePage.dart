import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weather_app/bloc/weather_cubit.dart';
import 'package:weather_app/bloc/weather_state.dart';

import 'package:weather_app/components/weather_card.dart';
import 'package:weather_app/services/gps_service.dart';
import 'package:weather_app/services/weather_service.dart';

import '../components/weather_animation_controller.dart';
import '../components/weather_forecast_components.dart';
import '../components/weather_search_components.dart';

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _cityController = TextEditingController();

  late WeatherAnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = WeatherAnimationController(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherCubit>().fetchWeatherForCurrnetLocation();
    });
  }

  void _showError(String title, String message, {bool showSettings = false}) {
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
        // Changed condition to use showSettings parameter, more flexible
        action: showSettings
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
    return BlocProvider(
      create: (context) => WeatherCubit(
        WeatherService(),
        GpsService(),
      ),
      child: ValueListenableBuilder<Color>(
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
              child: RefreshIndicator(
                color: Colors.white,
                backgroundColor: Colors.blueGrey,
                onRefresh: () async {
                  // Trigger refresh via Cubit
                  await context
                      .read<WeatherCubit>()
                      .fetchWeatherForCurrnetLocation();
                },
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(
                      parent:
                          AlwaysScrollableScrollPhysics()), // Added AlwaysScrollableScrollPhysics
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
                              onSubmitted: (city) {
                                // Calls Cubit method for city search
                                context
                                    .read<WeatherCubit>()
                                    .fetchWeatherForCity(city);
                                _cityController
                                    .clear(); // Clear input after submit
                              },
                              onLocationPressed: () {
                                // Calls Cubit method for current location
                                context
                                    .read<WeatherCubit>()
                                    .fetchWeatherForCurrnetLocation();
                                _cityController.clear(); // Clear input
                              },
                            ),
                            BlocConsumer<WeatherCubit, WeatherState>(
                              listener: (context, state) {
                                if (state is WeatherError) {
                                  _showError(
                                    state.isLocationError
                                        ? 'Location error'
                                        : 'Weather fetch error',
                                    state.message,
                                    showSettings: state.isLocationError,
                                  );
                                }
                                if (state is WeatherLoaded) {
                                  _animationController.updateBackgroundColor(
                                      state.currentWeather.description);
                                }
                              },
                              builder: (context, state) {
                                // Recent searches should come from WeatherLoaded state
                                if (state is WeatherLoaded) {
                                  return RecentSearches(
                                    searches:
                                        state.recentSearches, // Get from state
                                    onSearchSelected: (city) {
                                      _cityController.text = city;
                                      // Call Cubit method for recent search
                                      context
                                          .read<WeatherCubit>()
                                          .selectRecentSearch(city);
                                    },
                                  );
                                }
                                // If loading, and we had a previous loaded state, show its recent searches
                                if (state is WeatherLoading &&
                                    context.read<WeatherCubit>().state
                                        is WeatherLoaded) {
                                  return RecentSearches(
                                    searches: (context
                                            .read<WeatherCubit>()
                                            .state as WeatherLoaded)
                                        .recentSearches,
                                    onSearchSelected: (city) {
                                      _cityController.text = city;
                                      context
                                          .read<WeatherCubit>()
                                          .selectRecentSearch(city);
                                    },
                                  );
                                }
                                return const SizedBox
                                    .shrink(); // No recent searches to show initially or on error
                              },
                            ),
                            // Directly use the _buildWeatherContent that uses BlocBuilder
                            _buildWeatherContentBloc(), // Renamed to clearly differentiate
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
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
          'Mausam',
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

  Widget _buildWeatherContentBloc() {
    return BlocBuilder<WeatherCubit, WeatherState>(
      builder: (context, state) {
        if (state is WeatherLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
        } else if (state is WeatherLoaded) {
          return FadeTransition(
            opacity: _animationController.fadeAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                WeatherCard(
                  weather: state.currentWeather,
                  isDetailed: true,
                ),
                if (state.forecast.isNotEmpty)
                  WeatherForecast(forecast: state.forecast),
              ],
            ),
          );
        } else if (state is WeatherError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                '${state.message}',
                style: const TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cityController.dispose();
    super.dispose();
  }
}

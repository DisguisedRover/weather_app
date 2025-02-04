import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class GpsService {
  /// Checks and requests location permissions if needed.
  Future<bool> _checkPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false; // Permissions denied
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false; // Permissions denied forever
    }

    return true; // Permissions granted
  }

  /// Ensures location services are enabled.
  Future<bool> _checkLocationService() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }
    return true;
  }

  Future<bool> requestLocationPermission() async {
    // Request both location permissions
    await Permission.location.request();
    await Permission.locationAlways.request();

    // Check if permissions are granted
    if (await Permission.location.isGranted) {
      return true;
    }
    return false;
  }

  /// Gets the current location if permissions and services are enabled.
  Future<Position?> getCurrentLocation() async {
    try {
      // First check if location service is enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception(
            'Location services are disabled. Please enable them in settings.');
      }

      // Request permission
      bool hasPermission = await requestLocationPermission();
      if (!hasPermission) {
        throw Exception('Location permission denied');
      }

      // Get location
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      throw Exception('Error getting location: $e');
    }
  }

  /// Provides a stream of location updates.
  Stream<Position> getPositionStream({int distanceFilter = 10}) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilter,
      ),
    );
  }
}

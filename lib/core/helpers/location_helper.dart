import 'dart:async';
import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';

class LocationDetails {
  final double latitude;
  final double longitude;
  final String cityName;

  LocationDetails({
    required this.latitude,
    required this.longitude,
    required this.cityName,
  });
}

class LocationHelper {
  static Future<Position?> getCurrentPosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }

      if (permission == LocationPermission.deniedForever) return null;

      Position? lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null) {
        return lastKnown;
      }

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 7),
        ),
      );
    } catch (_) {
      return null;
    }
  }

  static Future<LocationDetails?> getCurrentCityAndLocation() async {
    try {
      final position = await getCurrentPosition();
      if (position == null) return null;

      String city = 'Current Location';

      try {
        final dio = Dio(
          BaseOptions(
            connectTimeout: const Duration(seconds: 5),
            receiveTimeout: const Duration(seconds: 5),
          ),
        );

        final response = await dio.get(
          'https://nominatim.openstreetmap.org/reverse',
          queryParameters: {
            'format': 'json',
            'lat': position.latitude,
            'lon': position.longitude,
            'zoom': 10,
            'addressdetails': 1,
            'accept-language': 'ar,en',
          },
          options: Options(
            headers: {'User-Agent': 'EasyShopApp_Flutter_Client/1.0'},
          ),
        );

        if (response.statusCode == 200 && response.data != null) {
          final address = response.data['address'] as Map<String, dynamic>?;
          if (address != null) {
            city =
                address['city'] ??
                address['town'] ??
                address['state'] ??
                address['village'] ??
                address['county'] ??
                'Egypt';
          }
        }
      } catch (_) {
        city =
            'Lat: ${position.latitude.toStringAsFixed(3)}, Lng: ${position.longitude.toStringAsFixed(3)}';
      }

      return LocationDetails(
        latitude: position.latitude,
        longitude: position.longitude,
        cityName: city,
      );
    } catch (_) {
      return null;
    }
  }
}

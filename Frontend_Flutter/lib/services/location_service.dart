// Location service - simplified version without external dependency
// You can add geolocator package later: flutter pub add geolocator

import 'dart:math';

class LocationService {
  // Calculate distance between two coordinates using Haversine formula
  static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadiusKm = 6371.0;

    final double latDistance = _toRadians(lat2 - lat1);
    final double lonDistance = _toRadians(lon2 - lon1);

    final double a = sin(latDistance / 2) * sin(latDistance / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(lonDistance / 2) *
            sin(lonDistance / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadiusKm * c;
  }

  static double _toRadians(double degrees) {
    return degrees * pi / 180;
  }

  // Mock current location - Hanoi coordinates
  // TODO: Replace with actual GPS using geolocator package
  static Future<LocationData> getCurrentLocation() async {
    // Simulate GPS delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Default: Hanoi coordinates
    return LocationData(
      latitude: 21.0285,
      longitude: 105.8542,
      address: 'Hà Nội, Việt Nam',
    );
  }

  // Calculate shipping fee
  static double calculateShippingFee(double distanceKm) {
    const double baseFee = 15000;
    const double freeDistanceKm = 3.0;
    const double additionalFeePerKm = 5000;

    if (distanceKm <= freeDistanceKm) {
      return baseFee;
    }

    final double additionalDistance = distanceKm - freeDistanceKm;
    final double additionalFee = additionalDistance * additionalFeePerKm;

    return baseFee + additionalFee;
  }
}

class LocationData {
  final double latitude;
  final double longitude;
  final String? address;

  LocationData({
    required this.latitude,
    required this.longitude,
    this.address,
  });
}

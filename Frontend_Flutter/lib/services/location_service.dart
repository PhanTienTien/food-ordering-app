import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

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

  // Check location permission
  static Future<bool> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    
    return true;
  }

  // Get current location using GPS
  static Future<LocationData> getCurrentLocation() async {
    bool hasPermission = await checkLocationPermission();
    
    if (!hasPermission) {
      // Return default location if permission denied
      return LocationData(
        latitude: 21.0285,
        longitude: 105.8542,
        address: 'Hà Nội, Việt Nam (Default)',
      );
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get address from coordinates (optional, requires geocoding package)
      String? address = await _getAddressFromCoordinates(
        position.latitude,
        position.longitude,
      );

      return LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
      );
    } catch (e) {
      // Fallback to default location on error
      return LocationData(
        latitude: 21.0285,
        longitude: 105.8542,
        address: 'Hà Nội, Việt Nam (Fallback)',
      );
    }
  }

  // Get address from coordinates (simplified - in real app use geocoding package)
  static Future<String?> _getAddressFromCoordinates(double lat, double lon) async {
    // In a real implementation, use geocoding package:
    // List<Placemark> placemarks = await placemarkFromCoordinates(lat, lon);
    // return placemarks.first.toString();
    
    // For now, return null (address can be fetched from backend)
    return null;
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

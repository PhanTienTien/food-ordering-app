import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/location_service.dart';

// Location State
class LocationState {
  final bool isLoading;
  final LocationData? currentLocation;
  final String? error;
  final bool hasPermission;

  LocationState({
    this.isLoading = false,
    this.currentLocation,
    this.error,
    this.hasPermission = false,
  });

  LocationState copyWith({
    bool? isLoading,
    LocationData? currentLocation,
    String? error,
    bool? hasPermission,
  }) {
    return LocationState(
      isLoading: isLoading ?? this.isLoading,
      currentLocation: currentLocation ?? this.currentLocation,
      error: error,
      hasPermission: hasPermission ?? this.hasPermission,
    );
  }
}

// Location Notifier
class LocationNotifier extends StateNotifier<LocationState> {
  LocationNotifier() : super(LocationState());

  // Get current location
  Future<void> getCurrentLocation() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final location = await LocationService.getCurrentLocation();
      state = state.copyWith(
        isLoading: false,
        currentLocation: location,
        hasPermission: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Không thể lấy vị trí: $e',
        hasPermission: false,
      );
    }
  }

  // Set location manually
  void setLocation(double latitude, double longitude, {String? address}) {
    state = state.copyWith(
      currentLocation: LocationData(
        latitude: latitude,
        longitude: longitude,
        address: address,
      ),
      hasPermission: true,
    );
  }

  // Calculate distance to a restaurant
  double calculateDistanceTo(double restaurantLat, double restaurantLon) {
    if (state.currentLocation == null) return -1;

    return LocationService.calculateDistance(
      state.currentLocation!.latitude,
      state.currentLocation!.longitude,
      restaurantLat,
      restaurantLon,
    );
  }

  // Calculate shipping fee to a restaurant
  double calculateShippingFee(double restaurantLat, double restaurantLon) {
    final distance = calculateDistanceTo(restaurantLat, restaurantLon);
    if (distance < 0) return 0;

    return LocationService.calculateShippingFee(distance);
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Location Provider
final locationProvider = StateNotifierProvider<LocationNotifier, LocationState>((ref) {
  return LocationNotifier();
});

// Simple providers
final currentLocationProvider = Provider<LocationData?>((ref) {
  return ref.watch(locationProvider).currentLocation;
});

final locationLoadingProvider = Provider<bool>((ref) {
  return ref.watch(locationProvider).isLoading;
});

final hasLocationPermissionProvider = Provider<bool>((ref) {
  return ref.watch(locationProvider).hasPermission;
});

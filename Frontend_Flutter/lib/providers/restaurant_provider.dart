import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/restaurant.dart';
import '../utils/error_utils.dart';
import '../services/restaurant_service.dart';

// Service Provider
final restaurantServiceProvider = Provider<RestaurantService>(
  (ref) => RestaurantService(),
);

// Restaurant List State
class RestaurantListState {
  final bool isLoading;
  final List<Restaurant> restaurants;
  final String? error;
  final bool isNearbyMode;

  RestaurantListState({
    this.isLoading = false,
    this.restaurants = const [],
    this.error,
    this.isNearbyMode = false,
  });

  RestaurantListState copyWith({
    bool? isLoading,
    List<Restaurant>? restaurants,
    String? error,
    bool? isNearbyMode,
  }) {
    return RestaurantListState(
      isLoading: isLoading ?? this.isLoading,
      restaurants: restaurants ?? this.restaurants,
      error: error,
      isNearbyMode: isNearbyMode ?? this.isNearbyMode,
    );
  }
}

// Restaurant Notifier
class RestaurantNotifier extends StateNotifier<RestaurantListState> {
  final RestaurantService _restaurantService;

  RestaurantNotifier(this._restaurantService) : super(RestaurantListState());

  // Load all restaurants
  Future<void> loadRestaurants() async {
    state = state.copyWith(isLoading: true, error: null, isNearbyMode: false);

    try {
      final restaurants = await _restaurantService.getOpenRestaurants();
      state = state.copyWith(isLoading: false, restaurants: restaurants);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: ErrorUtils.message(e));
    }
  }

  // Load nearby restaurants with distance
  Future<void> loadNearbyRestaurants({
    required double userLat,
    required double userLon,
    double radiusKm = 10.0,
  }) async {
    state = state.copyWith(isLoading: true, error: null, isNearbyMode: true);

    try {
      final nearbyData = await _restaurantService.getNearbyRestaurants(
        userLat: userLat,
        userLon: userLon,
        radiusKm: radiusKm,
      );

      final restaurants = nearbyData
          .map((data) {
            final rawRestaurant = data['restaurant'];
            final rawDistance = data['distanceKm'];
            final rawShippingFee = data['shippingFee'];

            if (rawRestaurant is! Map<String, dynamic> ||
                rawDistance is! num ||
                rawShippingFee is! num) {
              return null;
            }

            final restaurant = Restaurant.fromJson(rawRestaurant);
            return restaurant.copyWith(
              distanceKm: rawDistance.toDouble(),
              shippingFee: rawShippingFee.toDouble(),
            );
          })
          .whereType<Restaurant>()
          .toList();

      state = state.copyWith(isLoading: false, restaurants: restaurants);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: ErrorUtils.message(e));
    }
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Restaurant Provider
final restaurantProvider =
    StateNotifierProvider<RestaurantNotifier, RestaurantListState>((ref) {
      final service = ref.watch(restaurantServiceProvider);
      return RestaurantNotifier(service);
    });

// Simple providers
final restaurantsProvider = Provider<List<Restaurant>>((ref) {
  return ref.watch(restaurantProvider).restaurants;
});

final restaurantLoadingProvider = Provider<bool>((ref) {
  return ref.watch(restaurantProvider).isLoading;
});

final isNearbyModeProvider = Provider<bool>((ref) {
  return ref.watch(restaurantProvider).isNearbyMode;
});

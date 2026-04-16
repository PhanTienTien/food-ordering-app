import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/location_update.dart';
import '../services/tracking_service.dart';

// Tracking Service Provider
final trackingServiceProvider = Provider<TrackingService>((ref) => TrackingService());

// Tracking State
class TrackingState {
  final bool isConnected;
  final LocationUpdate? currentLocation;
  final String? status;
  final String? error;
  final int? subscribedOrderId;

  TrackingState({
    this.isConnected = false,
    this.currentLocation,
    this.status,
    this.error,
    this.subscribedOrderId,
  });

  TrackingState copyWith({
    bool? isConnected,
    LocationUpdate? currentLocation,
    String? status,
    String? error,
    int? subscribedOrderId,
  }) {
    return TrackingState(
      isConnected: isConnected ?? this.isConnected,
      currentLocation: currentLocation ?? this.currentLocation,
      status: status ?? this.status,
      error: error,
      subscribedOrderId: subscribedOrderId ?? this.subscribedOrderId,
    );
  }
}

// Tracking Notifier
class TrackingNotifier extends StateNotifier<TrackingState> {
  final TrackingService _trackingService;

  TrackingNotifier(this._trackingService) : super(TrackingState());

  // Connect to WebSocket
  void connect() {
    _trackingService.connect(
      onLocationUpdate: (update) {
        state = state.copyWith(
          currentLocation: update,
          status: update.status,
        );
      },
      onConnected: () {
        state = state.copyWith(isConnected: true, error: null);
      },
      onDisconnected: () {
        state = state.copyWith(isConnected: false);
      },
    );
  }

  // Subscribe to order tracking
  void subscribeToOrder(int orderId) {
    _trackingService.subscribeToOrder(orderId);
    state = state.copyWith(subscribedOrderId: orderId);
  }

  // Disconnect
  void disconnect() {
    _trackingService.disconnect();
    state = TrackingState();
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Tracking Provider
final trackingProvider = StateNotifierProvider<TrackingNotifier, TrackingState>((ref) {
  final service = ref.watch(trackingServiceProvider);
  return TrackingNotifier(service);
});

// Simple providers
final isTrackingConnectedProvider = Provider<bool>((ref) {
  return ref.watch(trackingProvider).isConnected;
});

final currentLocationProvider = Provider<LocationUpdate?>((ref) {
  return ref.watch(trackingProvider).currentLocation;
});

final trackingStatusProvider = Provider<String?>((ref) {
  return ref.watch(trackingProvider).status;
});

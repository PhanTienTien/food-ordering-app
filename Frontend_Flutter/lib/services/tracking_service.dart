import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import '../services/dio_client.dart';
import '../models/location_update.dart';
import '../utils/token_storage.dart';

class TrackingService {
  StompClient? _client;
  Function(LocationUpdate)? _onLocationUpdate;
  Function()? _onConnected;
  Function()? _onDisconnected;

  // Connect to WebSocket
  Future<void> connect({
    required Function(LocationUpdate) onLocationUpdate,
    Function()? onConnected,
    Function()? onDisconnected,
  }) async {
    _onLocationUpdate = onLocationUpdate;
    _onConnected = onConnected;
    _onDisconnected = onDisconnected;

    final token = await TokenStorage.getToken();
    final uri = Uri.parse(DioClient().dio.options.baseUrl);
    final wsUri = uri.replace(
      scheme: uri.scheme == 'https' ? 'wss' : 'ws',
      path: '/ws',
      query: '',
      fragment: '',
    );

    _client = StompClient(
      config: StompConfig(
        url: wsUri.toString(),
        onConnect: _onConnect,
        onDisconnect: _onDisconnect,
        onWebSocketError: (dynamic error) =>
            debugPrint('WebSocket Error: $error'),
        stompConnectHeaders: token != null
            ? {'Authorization': 'Bearer $token'}
            : {},
        webSocketConnectHeaders: token != null
            ? {'Authorization': 'Bearer $token'}
            : {},
      ),
    );

    _client?.activate();
  }

  void _onConnect(StompFrame frame) {
    debugPrint('Connected to WebSocket');
    _onConnected?.call();
  }

  void _onDisconnect(StompFrame frame) {
    debugPrint('Disconnected from WebSocket');
    _onDisconnected?.call();
  }

  // Subscribe to order tracking
  void subscribeToOrder(int orderId) {
    _client?.subscribe(
      destination: '/topic/tracking/$orderId',
      callback: (StompFrame frame) {
        if (frame.body != null) {
          final data = jsonDecode(frame.body!);
          final update = LocationUpdate.fromJson(data);
          _onLocationUpdate?.call(update);
        }
      },
    );
  }

  // Update driver location (for driver app)
  void updateLocation(
    int orderId,
    double latitude,
    double longitude,
    String status,
  ) {
    final update = LocationUpdate(
      orderId: orderId,
      latitude: latitude,
      longitude: longitude,
      status: status,
      timestamp: DateTime.now().toIso8601String(),
    );

    _client?.send(
      destination: '/app/tracking/$orderId/update',
      body: jsonEncode(update.toJson()),
    );
  }

  // Mark as delivered
  void markDelivered(int orderId) {
    _client?.send(destination: '/app/tracking/$orderId/delivered', body: '');
  }

  // Disconnect
  void disconnect() {
    _client?.deactivate();
    _client = null;
  }

  bool get isConnected => _client?.connected ?? false;
}

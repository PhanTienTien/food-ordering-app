import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order.dart';
import '../models/menu_item.dart';
import '../utils/error_utils.dart';
import '../services/staff_service.dart';

// Service Provider
final staffServiceProvider = Provider<StaffService>((ref) => StaffService());

// Staff Orders State
class StaffOrdersState {
  final bool isLoading;
  final List<Order> orders;
  final String? selectedStatus;
  final String? error;

  StaffOrdersState({
    this.isLoading = false,
    this.orders = const [],
    this.selectedStatus,
    this.error,
  });

  StaffOrdersState copyWith({
    bool? isLoading,
    List<Order>? orders,
    String? selectedStatus,
    String? error,
  }) {
    return StaffOrdersState(
      isLoading: isLoading ?? this.isLoading,
      orders: orders ?? this.orders,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      error: error,
    );
  }

  List<Order> get pendingOrders =>
      orders.where((o) => o.status == 'PENDING').toList();
  List<Order> get preparingOrders =>
      orders.where((o) => o.status == 'PREPARING').toList();
  List<Order> get readyOrders =>
      orders.where((o) => o.status == 'READY').toList();
}

// Staff Menu State
class StaffMenuState {
  final bool isLoading;
  final List<MenuItem> menuItems;
  final String? error;

  StaffMenuState({
    this.isLoading = false,
    this.menuItems = const [],
    this.error,
  });

  StaffMenuState copyWith({
    bool? isLoading,
    List<MenuItem>? menuItems,
    String? error,
  }) {
    return StaffMenuState(
      isLoading: isLoading ?? this.isLoading,
      menuItems: menuItems ?? this.menuItems,
      error: error,
    );
  }
}

// Staff Orders Notifier
class StaffOrdersNotifier extends StateNotifier<StaffOrdersState> {
  final StaffService _staffService;
  int? _restaurantId;
  int? _staffId;

  StaffOrdersNotifier(this._staffService) : super(StaffOrdersState());

  void setIds(int restaurantId, int staffId) {
    _restaurantId = restaurantId;
    _staffId = staffId;
  }

  // Load orders
  Future<void> loadOrders() async {
    if (_restaurantId == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final orders = await _staffService.getRestaurantOrders(_restaurantId!);
      state = state.copyWith(isLoading: false, orders: orders);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: ErrorUtils.message(e));
    }
  }

  // Filter by status
  Future<void> filterByStatus(String status) async {
    if (_restaurantId == null) return;

    state = state.copyWith(
      isLoading: true,
      error: null,
      selectedStatus: status,
    );

    try {
      final orders = await _staffService.getOrdersByStatus(
        _restaurantId!,
        status,
      );
      state = state.copyWith(isLoading: false, orders: orders);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: ErrorUtils.message(e));
    }
  }

  // Accept order
  Future<bool> acceptOrder(int orderId) async {
    if (_staffId == null) return false;

    try {
      await _staffService.acceptOrder(orderId, _staffId!);
      await loadOrders();
      return true;
    } catch (e) {
      state = state.copyWith(error: ErrorUtils.message(e));
      return false;
    }
  }

  // Mark preparing
  Future<bool> markPreparing(int orderId) async {
    if (_staffId == null) return false;

    try {
      await _staffService.markPreparing(orderId, _staffId!);
      await loadOrders();
      return true;
    } catch (e) {
      state = state.copyWith(error: ErrorUtils.message(e));
      return false;
    }
  }

  // Mark ready
  Future<bool> markReady(int orderId) async {
    if (_staffId == null) return false;

    try {
      await _staffService.markReady(orderId, _staffId!);
      await loadOrders();
      return true;
    } catch (e) {
      state = state.copyWith(error: ErrorUtils.message(e));
      return false;
    }
  }

  // Mark delivered
  Future<bool> markDelivered(int orderId) async {
    if (_staffId == null) return false;

    try {
      await _staffService.markDelivered(orderId, _staffId!);
      await loadOrders();
      return true;
    } catch (e) {
      state = state.copyWith(error: ErrorUtils.message(e));
      return false;
    }
  }

  // Cancel order
  Future<bool> cancelOrder(int orderId, String reason) async {
    if (_staffId == null) return false;

    try {
      await _staffService.cancelOrder(orderId, _staffId!, reason);
      await loadOrders();
      return true;
    } catch (e) {
      state = state.copyWith(error: ErrorUtils.message(e));
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Staff Menu Notifier
class StaffMenuNotifier extends StateNotifier<StaffMenuState> {
  final StaffService _staffService;
  int? _restaurantId;

  StaffMenuNotifier(this._staffService) : super(StaffMenuState());

  void setRestaurantId(int restaurantId) {
    _restaurantId = restaurantId;
  }

  // Load menu items
  Future<void> loadMenuItems() async {
    if (_restaurantId == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final items = await _staffService.getRestaurantMenuItems(_restaurantId!);
      state = state.copyWith(isLoading: false, menuItems: items);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: ErrorUtils.message(e));
    }
  }

  // Toggle item status
  Future<bool> toggleItemStatus(int itemId, String status) async {
    try {
      await _staffService.toggleItemStatus(itemId, status);
      await loadMenuItems();
      return true;
    } catch (e) {
      state = state.copyWith(error: ErrorUtils.message(e));
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  Future<bool> updateItemPrice(
    int itemId,
    double price,
    double discountPrice,
  ) async {
    try {
      await _staffService.updateItemPrice(itemId, price, discountPrice);
      await loadMenuItems();
      return true;
    } catch (e) {
      state = state.copyWith(error: ErrorUtils.message(e));
      return false;
    }
  }

  Future<bool> createMenuItem(Map<String, dynamic> data) async {
    try {
      await _staffService.createMenuItem(data);
      await loadMenuItems();
      return true;
    } catch (e) {
      state = state.copyWith(error: ErrorUtils.message(e));
      return false;
    }
  }

  Future<bool> deleteMenuItem(int itemId) async {
    try {
      await _staffService.deleteMenuItem(itemId);
      await loadMenuItems();
      return true;
    } catch (e) {
      state = state.copyWith(error: ErrorUtils.message(e));
      return false;
    }
  }
}

// Providers
final staffOrdersProvider =
    StateNotifierProvider<StaffOrdersNotifier, StaffOrdersState>((ref) {
      final service = ref.watch(staffServiceProvider);
      return StaffOrdersNotifier(service);
    });

final staffMenuProvider =
    StateNotifierProvider<StaffMenuNotifier, StaffMenuState>((ref) {
      final service = ref.watch(staffServiceProvider);
      return StaffMenuNotifier(service);
    });

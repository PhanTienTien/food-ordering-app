import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order.dart';
import '../models/checkout_request.dart';
import '../utils/error_utils.dart';
import '../services/order_service.dart';
import 'cart_provider.dart';

// Order Service Provider
final orderServiceProvider = Provider<OrderService>((ref) => OrderService());

// Order List State
class OrderListState {
  final bool isLoading;
  final List<Order> orders;
  final String? error;

  OrderListState({this.isLoading = false, this.orders = const [], this.error});

  OrderListState copyWith({
    bool? isLoading,
    List<Order>? orders,
    String? error,
  }) {
    return OrderListState(
      isLoading: isLoading ?? this.isLoading,
      orders: orders ?? this.orders,
      error: error,
    );
  }
}

// Order Action State (for single order operations like checkout)
class OrderActionState {
  final bool isLoading;
  final Order? currentOrder;
  final String? error;

  OrderActionState({this.isLoading = false, this.currentOrder, this.error});

  OrderActionState copyWith({
    bool? isLoading,
    Order? currentOrder,
    String? error,
  }) {
    return OrderActionState(
      isLoading: isLoading ?? this.isLoading,
      currentOrder: currentOrder ?? this.currentOrder,
      error: error,
    );
  }
}

// Order List Notifier
class OrderListNotifier extends StateNotifier<OrderListState> {
  final OrderService _orderService;

  OrderListNotifier(this._orderService) : super(OrderListState());

  // Load order history
  Future<void> loadOrderHistory() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final orders = await _orderService.getOrderHistory();
      state = state.copyWith(isLoading: false, orders: orders);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: ErrorUtils.message(e));
    }
  }
}

// Order Action Notifier
class OrderActionNotifier extends StateNotifier<OrderActionState> {
  final OrderService _orderService;
  final Ref _ref;

  OrderActionNotifier(this._orderService, this._ref)
    : super(OrderActionState());

  // Checkout - create order from cart
  Future<bool> checkout([CheckoutRequest? request]) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final order = await _orderService.checkout(request);
      state = state.copyWith(isLoading: false, currentOrder: order);

      // Clear cart after successful checkout
      _ref.read(cartProvider.notifier).clearCart();

      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: ErrorUtils.message(e));
      return false;
    }
  }

  // Cancel order
  Future<bool> cancelOrder(int orderId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final order = await _orderService.cancelOrder(orderId);
      state = state.copyWith(isLoading: false, currentOrder: order);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: ErrorUtils.message(e));
      return false;
    }
  }

  // Get order details
  Future<void> getOrderDetails(int orderId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final order = await _orderService.getOrderDetails(orderId);
      state = state.copyWith(isLoading: false, currentOrder: order);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: ErrorUtils.message(e));
    }
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  // Clear current order
  void clearCurrentOrder() {
    state = state.copyWith(currentOrder: null);
  }
}

// Order List Provider
final orderListProvider =
    StateNotifierProvider<OrderListNotifier, OrderListState>((ref) {
      final orderService = ref.watch(orderServiceProvider);
      return OrderListNotifier(orderService);
    });

// Order Action Provider
final orderActionProvider =
    StateNotifierProvider<OrderActionNotifier, OrderActionState>((ref) {
      final orderService = ref.watch(orderServiceProvider);
      return OrderActionNotifier(orderService, ref);
    });

// Simple providers
final orderHistoryProvider = Provider<List<Order>>((ref) {
  return ref.watch(orderListProvider).orders;
});

final currentOrderProvider = Provider<Order?>((ref) {
  return ref.watch(orderActionProvider).currentOrder;
});

final orderLoadingProvider = Provider<bool>((ref) {
  return ref.watch(orderListProvider).isLoading ||
      ref.watch(orderActionProvider).isLoading;
});

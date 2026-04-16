import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/cart.dart';
import '../services/cart_service.dart';

// Cart Service Provider
final cartServiceProvider = Provider<CartService>((ref) => CartService());

// Cart State
class CartState {
  final bool isLoading;
  final Cart? cart;
  final String? error;

  CartState({
    this.isLoading = false,
    this.cart,
    this.error,
  });

  CartState copyWith({
    bool? isLoading,
    Cart? cart,
    String? error,
  }) {
    return CartState(
      isLoading: isLoading ?? this.isLoading,
      cart: cart ?? this.cart,
      error: error,
    );
  }

  // Helper getters
  int get itemCount => cart?.items.length ?? 0;
  double get totalAmount => cart?.totalAmount ?? 0.0;
  bool get isEmpty => cart?.items.isEmpty ?? true;
}

// Cart Notifier
class CartNotifier extends StateNotifier<CartState> {
  final CartService _cartService;

  CartNotifier(this._cartService) : super(CartState());

  // Load cart
  Future<void> loadCart() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final cart = await _cartService.getCart();
      state = state.copyWith(isLoading: false, cart: cart);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Add item to cart
  Future<void> addToCart(int menuItemId, int quantity) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final cart = await _cartService.addToCart(
        menuItemId: menuItemId,
        quantity: quantity,
      );
      state = state.copyWith(isLoading: false, cart: cart);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Update quantity
  Future<void> updateQuantity(int menuItemId, int quantity) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final cart = await _cartService.updateQuantity(
        menuItemId: menuItemId,
        quantity: quantity,
      );
      state = state.copyWith(isLoading: false, cart: cart);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Remove item (set quantity to 0)
  Future<void> removeItem(int menuItemId) async {
    await updateQuantity(menuItemId, 0);
  }

  // Clear cart
  Future<void> clearCart() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _cartService.clearCart();
      state = state.copyWith(isLoading: false, cart: null);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Cart Notifier Provider
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  final cartService = ref.watch(cartServiceProvider);
  return CartNotifier(cartService);
});

// Simple providers
final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).itemCount;
});

final cartTotalProvider = Provider<double>((ref) {
  return ref.watch(cartProvider).totalAmount;
});

final cartLoadingProvider = Provider<bool>((ref) {
  return ref.watch(cartProvider).isLoading;
});

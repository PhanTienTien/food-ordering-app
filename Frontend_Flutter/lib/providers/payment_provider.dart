import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order.dart';
import '../models/checkout_request.dart';
import '../models/payment_request.dart';
import '../services/order_service.dart';
import 'cart_provider.dart';

// Payment Method Enum
enum PaymentMethod {
  cod('COD', 'Tiền mặt khi nhận hàng'),
  vnpay('VNPAY', 'Thanh toán VNPay'),
  momo('MOMO', 'Ví MoMo'),
  card('CARD', 'Thẻ tín dụng/Ghi nợ');

  final String code;
  final String label;

  const PaymentMethod(this.code, this.label);
}

// Payment State
class PaymentState {
  final bool isLoading;
  final PaymentMethod selectedMethod;
  final Order? currentOrder;
  final String? error;
  final bool paymentSuccess;

  PaymentState({
    this.isLoading = false,
    this.selectedMethod = PaymentMethod.cod,
    this.currentOrder,
    this.error,
    this.paymentSuccess = false,
  });

  PaymentState copyWith({
    bool? isLoading,
    PaymentMethod? selectedMethod,
    Order? currentOrder,
    String? error,
    bool? paymentSuccess,
  }) {
    return PaymentState(
      isLoading: isLoading ?? this.isLoading,
      selectedMethod: selectedMethod ?? this.selectedMethod,
      currentOrder: currentOrder ?? this.currentOrder,
      error: error,
      paymentSuccess: paymentSuccess ?? this.paymentSuccess,
    );
  }
}

// Payment Notifier
class PaymentNotifier extends StateNotifier<PaymentState> {
  final OrderService _orderService;
  final Ref _ref;

  PaymentNotifier(this._orderService, this._ref) : super(PaymentState());

  // Select payment method
  void selectPaymentMethod(PaymentMethod method) {
    state = state.copyWith(selectedMethod: method);
  }

  // Checkout
  Future<bool> checkout(CheckoutRequest request) async {
    state = state.copyWith(isLoading: true, error: null, paymentSuccess: false);

    try {
      final order = await _orderService.checkoutWithDetails(request);
      state = state.copyWith(isLoading: false, currentOrder: order);

      // Clear cart after successful checkout
      _ref.read(cartProvider.notifier).clearCart();

      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
      return false;
    }
  }

  // Process payment
  Future<bool> processPayment(int orderId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final request = PaymentRequest(
        paymentMethod: state.selectedMethod.code,
        simulateSuccess: true, // For testing
      );

      final order = await _orderService.processPayment(orderId, request);
      state = state.copyWith(
        isLoading: false,
        currentOrder: order,
        paymentSuccess: order.paymentStatus == 'PAID',
      );

      return order.paymentStatus == 'PAID';
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
        paymentSuccess: false,
      );
      return false;
    }
  }

  // Clear state
  void clearState() {
    state = PaymentState();
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Payment Provider
final paymentProvider = StateNotifierProvider<PaymentNotifier, PaymentState>((ref) {
  final orderService = ref.watch(orderServiceProvider);
  return PaymentNotifier(orderService, ref);
});

// Simple providers
final selectedPaymentMethodProvider = Provider<PaymentMethod>((ref) {
  return ref.watch(paymentProvider).selectedMethod;
});

final currentOrderProvider = Provider<Order?>((ref) {
  return ref.watch(paymentProvider).currentOrder;
});

final paymentSuccessProvider = Provider<bool>((ref) {
  return ref.watch(paymentProvider).paymentSuccess;
});

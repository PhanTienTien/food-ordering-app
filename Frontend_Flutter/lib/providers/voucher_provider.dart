import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/voucher.dart';
import '../services/voucher_service.dart';

final voucherServiceProvider = Provider<VoucherService>((ref) => VoucherService());

class VoucherState {
  final bool isLoading;
  final List<Voucher> vouchers;
  final String? error;
  final Voucher? appliedVoucher;
  final double? discountAmount;

  VoucherState({
    this.isLoading = false,
    this.vouchers = const [],
    this.error,
    this.appliedVoucher,
    this.discountAmount,
  });

  VoucherState copyWith({
    bool? isLoading,
    List<Voucher>? vouchers,
    String? error,
    Voucher? appliedVoucher,
    double? discountAmount,
  }) {
    return VoucherState(
      isLoading: isLoading ?? this.isLoading,
      vouchers: vouchers ?? this.vouchers,
      error: error,
      appliedVoucher: appliedVoucher ?? this.appliedVoucher,
      discountAmount: discountAmount ?? this.discountAmount,
    );
  }
}

class VoucherNotifier extends StateNotifier<VoucherState> {
  final VoucherService _voucherService;

  VoucherNotifier(this._voucherService) : super(VoucherState());

  Future<void> loadActiveVouchers() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final vouchers = await _voucherService.getActiveVouchers();
      state = state.copyWith(isLoading: false, vouchers: vouchers);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> applyVoucher(String code, double orderAmount) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final discountAmount = await _voucherService.validateVoucher(code, orderAmount);
      final voucher = await _voucherService.getVoucherByCode(code);
      state = state.copyWith(
        isLoading: false,
        appliedVoucher: voucher,
        discountAmount: discountAmount,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearVoucher() {
    state = state.copyWith(
      appliedVoucher: null,
      discountAmount: null,
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final voucherProvider = StateNotifierProvider<VoucherNotifier, VoucherState>((ref) {
  final voucherService = ref.watch(voucherServiceProvider);
  return VoucherNotifier(voucherService);
});

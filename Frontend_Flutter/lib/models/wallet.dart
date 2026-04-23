import 'package:freezed_annotation/freezed_annotation.dart';

part 'wallet.freezed.dart';
part 'wallet.g.dart';

@freezed
class Wallet with _$Wallet {
  const factory Wallet({
    int? id,
    int? userId,
    double? balance,
    int? points,
    double? totalEarned,
    double? totalSpent,
    String? createdAt,
  }) = _Wallet;

  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);
}

@freezed
class WalletTransaction with _$WalletTransaction {
  const factory WalletTransaction({
    int? id,
    int? walletId,
    String? type,
    double? amount,
    double? balanceAfter,
    String? description,
    int? referenceId,
    String? referenceType,
    String? createdAt,
  }) = _WalletTransaction;

  factory WalletTransaction.fromJson(Map<String, dynamic> json) =>
      _$WalletTransactionFromJson(json);
}

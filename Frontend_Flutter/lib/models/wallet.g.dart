// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WalletImpl _$$WalletImplFromJson(Map<String, dynamic> json) => _$WalletImpl(
  id: (json['id'] as num?)?.toInt(),
  userId: (json['userId'] as num?)?.toInt(),
  balance: (json['balance'] as num?)?.toDouble(),
  points: (json['points'] as num?)?.toInt(),
  totalEarned: (json['totalEarned'] as num?)?.toDouble(),
  totalSpent: (json['totalSpent'] as num?)?.toDouble(),
  createdAt: json['createdAt'] as String?,
);

Map<String, dynamic> _$$WalletImplToJson(_$WalletImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'balance': instance.balance,
      'points': instance.points,
      'totalEarned': instance.totalEarned,
      'totalSpent': instance.totalSpent,
      'createdAt': instance.createdAt,
    };

_$WalletTransactionImpl _$$WalletTransactionImplFromJson(
  Map<String, dynamic> json,
) => _$WalletTransactionImpl(
  id: (json['id'] as num?)?.toInt(),
  walletId: (json['walletId'] as num?)?.toInt(),
  type: json['type'] as String?,
  amount: (json['amount'] as num?)?.toDouble(),
  balanceAfter: (json['balanceAfter'] as num?)?.toDouble(),
  description: json['description'] as String?,
  referenceId: (json['referenceId'] as num?)?.toInt(),
  referenceType: json['referenceType'] as String?,
  createdAt: json['createdAt'] as String?,
);

Map<String, dynamic> _$$WalletTransactionImplToJson(
  _$WalletTransactionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'walletId': instance.walletId,
  'type': instance.type,
  'amount': instance.amount,
  'balanceAfter': instance.balanceAfter,
  'description': instance.description,
  'referenceId': instance.referenceId,
  'referenceType': instance.referenceType,
  'createdAt': instance.createdAt,
};

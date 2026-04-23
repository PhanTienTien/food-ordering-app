// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/colors.dart';
import '../models/wallet.dart';
import '../services/wallet_service.dart';

class WalletScreen extends ConsumerStatefulWidget {
  final int userId;

  const WalletScreen({required this.userId, super.key});

  @override
  ConsumerState<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends ConsumerState<WalletScreen> {
  final WalletService _walletService = WalletService();
  Wallet? wallet;
  List<WalletTransaction> transactions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWalletData();
  }

  Future<void> _loadWalletData() async {
    try {
      final loadedWallet = await _walletService.getWalletByUser(widget.userId);
      final loadedTransactions = await _walletService.getTransactionHistory(
        widget.userId,
      );
      setState(() {
        wallet = loadedWallet;
        transactions = loadedTransactions;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Ví & Điểm'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : wallet == null
          ? _createWalletButton()
          : SingleChildScrollView(
              child: Column(
                children: [
                  _WalletBalanceCard(wallet: wallet!),
                  _PointsCard(wallet: wallet!),
                  _TransactionHistory(transactions: transactions),
                ],
              ),
            ),
    );
  }

  Widget _createWalletButton() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () async {
            try {
              await _walletService.createWallet(widget.userId);
              if (!mounted) return;
              await _loadWalletData();
            } catch (e) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
            }
          },
          child: Text('Tạo ví'),
        ),
      ),
    );
  }
}

class _WalletBalanceCard extends StatelessWidget {
  final Wallet wallet;

  const _WalletBalanceCard({required this.wallet});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withAlpha(204)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Số dư ví',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          SizedBox(height: 8),
          Text(
            '${wallet.balance?.toStringAsFixed(0) ?? '0'}đ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              _StatItem(
                label: 'Đã nạp',
                value: '${wallet.totalEarned?.toStringAsFixed(0) ?? '0'}đ',
              ),
              SizedBox(width: 24),
              _StatItem(
                label: 'Đã tiêu',
                value: '${wallet.totalSpent?.toStringAsFixed(0) ?? '0'}đ',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 12)),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _PointsCard extends StatelessWidget {
  final Wallet wallet;

  const _PointsCard({required this.wallet});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.withAlpha(26),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.stars, color: Colors.amber, size: 28),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Điểm tích lũy',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 4),
                Text(
                  '${wallet.points ?? 0} điểm',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionHistory extends StatelessWidget {
  final List<WalletTransaction> transactions;

  const _TransactionHistory({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lịch sử giao dịch',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          if (transactions.isEmpty)
            Center(child: Text('Chưa có giao dịch nào'))
          else
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                return _TransactionCard(transaction: transactions[index]);
              },
            ),
        ],
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final WalletTransaction transaction;

  const _TransactionCard({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final isPositive = (transaction.amount ?? 0) >= 0;
    final color = isPositive ? Colors.green : Colors.red;
    final icon = _getIconForType(transaction.type);

    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withAlpha(26),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        title: Text(transaction.description ?? ''),
        subtitle: Text(transaction.createdAt ?? ''),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${isPositive ? '+' : ''}${transaction.amount?.toStringAsFixed(0) ?? '0'}đ',
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
            Text(
              'Số dư: ${transaction.balanceAfter?.toStringAsFixed(0) ?? '0'}đ',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForType(String? type) {
    switch (type) {
      case 'DEPOSIT':
        return Icons.arrow_downward;
      case 'PAYMENT':
        return Icons.shopping_cart;
      case 'REFUND':
        return Icons.refresh;
      case 'REWARD':
        return Icons.card_giftcard;
      case 'POINTS_REDEEM':
        return Icons.stars;
      default:
        return Icons.account_balance_wallet;
    }
  }
}

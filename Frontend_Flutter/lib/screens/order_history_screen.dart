import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/colors.dart';
import '../models/order.dart';
import '../providers/auth_provider.dart';
import '../services/order_service.dart';

class OrderHistoryScreen extends ConsumerStatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  ConsumerState<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends ConsumerState<OrderHistoryScreen> {
  final OrderService _orderService = OrderService();
  List<Order> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final userId = ref.read(authProvider).userId;
      if (userId == null) {
        if (!mounted) return;
        setState(() => isLoading = false);
        return;
      }
      final loaded = await _orderService.getOrderHistory();
      if (!mounted) return;
      setState(() {
        orders = loaded;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  Future<void> _showOrderDetail(Order order) async {
    if (order.id == null) return;
    try {
      final detail = await _orderService.getOrderDetails(order.id!);
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Đơn #${detail.id ?? order.id}'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Trạng thái: ${detail.status ?? ''}'),
                Text('Nhà hàng: ${detail.restaurantName ?? ''}'),
                Text('Tổng: ${detail.finalPrice ?? detail.totalPrice ?? 0}'),
                const SizedBox(height: 12),
                const Text(
                  'Món ăn:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...detail.items.map(
                  (item) => Text(
                    '- ${item.menuItem?.name ?? ''} x${item.quantity ?? 0}',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Đóng'),
            ),
          ],
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Orders", style: TextStyle(color: Colors.black)),
        leading: const BackButton(),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadOrders),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
          ? const Center(child: Text('Chưa có đơn hàng nào'))
          : RefreshIndicator(
              onRefresh: _loadOrders,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return _orderItem(order);
                },
              ),
            ),
    );
  }

  Widget _orderItem(Order order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '#${order.id ?? ''}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                order.status ?? '',
                style: TextStyle(
                  color: order.status == 'COMPLETED'
                      ? Colors.green
                      : AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text('Ngày: ${order.createdAt ?? ''}'),
          Text('Tổng: ${order.finalPrice ?? order.totalPrice ?? 0}'),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _showOrderDetail(order),
              child: const Text("View Detail"),
            ),
          ),
        ],
      ),
    );
  }
}

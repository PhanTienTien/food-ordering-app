import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/colors.dart';
import '../../models/order.dart';
import '../../providers/staff_provider.dart';

class StaffOrdersScreen extends ConsumerStatefulWidget {
  final int restaurantId;
  final int staffId;

  const StaffOrdersScreen({
    super.key,
    required this.restaurantId,
    required this.staffId,
  });

  @override
  ConsumerState<StaffOrdersScreen> createState() => _StaffOrdersScreenState();
}

class _StaffOrdersScreenState extends ConsumerState<StaffOrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(staffOrdersProvider.notifier).setIds(
            widget.restaurantId,
            widget.staffId,
          );
      ref.read(staffOrdersProvider.notifier).loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(staffOrdersProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Quản lý đơn hàng',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () {
              ref.read(staffOrdersProvider.notifier).loadOrders();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Status Filter
          _buildStatusFilter(state.selectedStatus),

          // Stats Row
          _buildStatsRow(state),

          // Orders List
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.error != null
                    ? Center(child: Text('Lỗi: ${state.error}'))
                    : state.orders.isEmpty
                        ? const Center(child: Text('Không có đơn hàng'))
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: state.orders.length,
                            itemBuilder: (context, index) {
                              return _OrderCard(
                                order: state.orders[index],
                                onAccept: () => _handleAccept(state.orders[index].id!),
                                onPreparing: () => _handlePreparing(state.orders[index].id!),
                                onReady: () => _handleReady(state.orders[index].id!),
                                onDelivered: () => _handleDelivered(state.orders[index].id!),
                                onCancel: () => _showCancelDialog(state.orders[index].id!),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilter(String? selectedStatus) {
    final statuses = ['Tất cả', 'PENDING', 'PREPARING', 'READY', 'COMPLETED'];

    return Container(
      height: 50,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: statuses.length,
        itemBuilder: (context, index) {
          final status = statuses[index];
          final isSelected = selectedStatus == status ||
              (selectedStatus == null && status == 'Tất cả');

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(_getStatusLabel(status)),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  if (status == 'Tất cả') {
                    ref.read(staffOrdersProvider.notifier).loadOrders();
                  } else {
                    ref.read(staffOrdersProvider.notifier).filterByStatus(status);
                  }
                }
              },
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          );
        },
      ),
    );
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'PENDING':
        return 'Chờ xác nhận';
      case 'PREPARING':
        return 'Đang chuẩn bị';
      case 'READY':
        return 'Sẵn sàng';
      case 'COMPLETED':
        return 'Hoàn thành';
      default:
        return status;
    }
  }

  Widget _buildStatsRow(StaffOrdersState state) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('Chờ xác nhận', state.pendingOrders.length, Colors.orange),
          _buildStatItem('Đang chuẩn bị', state.preparingOrders.length, Colors.blue),
          _buildStatItem('Sẵn sàng', state.readyOrders.length, Colors.green),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Future<void> _handleAccept(int orderId) async {
    final success = await ref.read(staffOrdersProvider.notifier).acceptOrder(orderId);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã chấp nhận đơn hàng')),
      );
    }
  }

  Future<void> _handlePreparing(int orderId) async {
    final success = await ref.read(staffOrdersProvider.notifier).markPreparing(orderId);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đang chuẩn bị đơn hàng')),
      );
    }
  }

  Future<void> _handleReady(int orderId) async {
    final success = await ref.read(staffOrdersProvider.notifier).markReady(orderId);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đơn hàng sẵn sàng giao')),
      );
    }
  }

  Future<void> _handleDelivered(int orderId) async {
    final success = await ref.read(staffOrdersProvider.notifier).markDelivered(orderId);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đơn hàng đã giao')),
      );
    }
  }

  void _showCancelDialog(int orderId) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hủy đơn hàng'),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(
            labelText: 'Lý do hủy',
            hintText: 'Nhập lý do hủy đơn...',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await ref
                  .read(staffOrdersProvider.notifier)
                  .cancelOrder(orderId, reasonController.text);
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã hủy đơn hàng')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xác nhận hủy'),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onAccept;
  final VoidCallback onPreparing;
  final VoidCallback onReady;
  final VoidCallback onDelivered;
  final VoidCallback onCancel;

  const _OrderCard({
    required this.order,
    required this.onAccept,
    required this.onPreparing,
    required this.onReady,
    required this.onDelivered,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Đơn #${order.id}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                _buildStatusChip(order.status ?? 'PENDING'),
              ],
            ),
            const SizedBox(height: 8),

            // Customer Info
            Text('Khách: ${order.userName ?? "Không tên"}'),
            Text('Tổng: ${order.finalPrice?.toStringAsFixed(0) ?? "0"} đ'),
            const SizedBox(height: 12),

            // Items
            if (order.items != null && order.items!.isNotEmpty)
              ...order.items!.map((item) => Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 4),
                    child: Text(
                      '- ${item.menuItem?.name ?? "Món"} x${item.quantity}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  )),

            const Divider(),

            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'PENDING':
        color = Colors.orange;
        break;
      case 'PREPARING':
        color = Colors.blue;
        break;
      case 'READY':
        color = Colors.green;
        break;
      case 'COMPLETED':
        color = Colors.purple;
        break;
      case 'CANCELLED':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Chip(
      label: Text(
        status,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: color,
      padding: EdgeInsets.zero,
    );
  }

  Widget _buildActionButtons() {
    final status = order.status ?? 'PENDING';

    if (status == 'PENDING') {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: onAccept,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Chấp nhận'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton(
              onPressed: onCancel,
              style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Từ chối'),
            ),
          ),
        ],
      );
    } else if (status == 'ACCEPTED') {
      return ElevatedButton(
        onPressed: onPreparing,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        child: const Text('Bắt đầu chuẩn bị'),
      );
    } else if (status == 'PREPARING') {
      return ElevatedButton(
        onPressed: onReady,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
        child: const Text('Đã chuẩn bị xong'),
      );
    } else if (status == 'READY') {
      return ElevatedButton(
        onPressed: onDelivered,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
        child: const Text('Đã giao cho shipper'),
      );
    }

    return const SizedBox.shrink();
  }
}

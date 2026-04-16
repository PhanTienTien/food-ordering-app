import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/colors.dart';
import '../../models/menu_item.dart';
import '../../providers/staff_provider.dart';

class StaffMenuScreen extends ConsumerStatefulWidget {
  final int restaurantId;

  const StaffMenuScreen({
    super.key,
    required this.restaurantId,
  });

  @override
  ConsumerState<StaffMenuScreen> createState() => _StaffMenuScreenState();
}

class _StaffMenuScreenState extends ConsumerState<StaffMenuScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(staffMenuProvider.notifier).setRestaurantId(widget.restaurantId);
      ref.read(staffMenuProvider.notifier).loadMenuItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(staffMenuProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Quản lý thực đơn',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () {
              ref.read(staffMenuProvider.notifier).loadMenuItems();
            },
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () {
              // TODO: Navigate to add menu item screen
            },
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? Center(child: Text('Lỗi: ${state.error}'))
              : state.menuItems.isEmpty
                  ? const Center(child: Text('Chưa có món nào'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.menuItems.length,
                      itemBuilder: (context, index) {
                        return _MenuItemCard(
                          item: state.menuItems[index],
                          onToggleStatus: () => _toggleStatus(state.menuItems[index]),
                          onEdit: () => _showEditDialog(state.menuItems[index]),
                        );
                      },
                    ),
    );
  }

  Future<void> _toggleStatus(MenuItem item) async {
    final newStatus = item.status == 'AVAILABLE' ? 'OUT_OF_STOCK' : 'AVAILABLE';
    final success = await ref.read(staffMenuProvider.notifier).toggleItemStatus(
          item.id!,
          newStatus,
        );
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newStatus == 'AVAILABLE'
                ? '${item.name} đã bật bán'
                : '${item.name} đã tắt bán',
          ),
        ),
      );
    }
  }

  void _showEditDialog(MenuItem item) {
    final priceController = TextEditingController(
      text: item.price?.toStringAsFixed(0) ?? '',
    );
    final discountController = TextEditingController(
      text: item.discountPrice?.toStringAsFixed(0) ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sửa: ${item.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Giá gốc',
                suffixText: 'đ',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: discountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Giá khuyến mãi',
                suffixText: 'đ',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Call update price API
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã cập nhật giá')),
              );
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final MenuItem item;
  final VoidCallback onToggleStatus;
  final VoidCallback onEdit;

  const _MenuItemCard({
    required this.item,
    required this.onToggleStatus,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isAvailable = item.status == 'AVAILABLE';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            item.image ?? 'https://via.placeholder.com/60',
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 60,
              height: 60,
              color: Colors.grey[300],
              child: const Icon(Icons.image_not_supported),
            ),
          ),
        ),
        title: Text(
          item.name ?? 'Không tên',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: isAvailable ? null : TextDecoration.lineThrough,
            color: isAvailable ? Colors.black : Colors.grey,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            if (item.discountPrice != null && item.discountPrice! > 0) ...[
              Text(
                '${item.price?.toStringAsFixed(0) ?? "0"} đ',
                style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              Text(
                '${item.discountPrice?.toStringAsFixed(0) ?? "0"} đ',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ] else
              Text(
                '${item.price?.toStringAsFixed(0) ?? "0"} đ',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isAvailable ? Colors.green[100] : Colors.red[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                isAvailable ? 'Còn hàng' : 'Hết hàng',
                style: TextStyle(
                  color: isAvailable ? Colors.green[700] : Colors.red[700],
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
            Switch(
              value: isAvailable,
              onChanged: (_) => onToggleStatus(),
              activeColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}

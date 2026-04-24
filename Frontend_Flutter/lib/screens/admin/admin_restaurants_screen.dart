import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/colors.dart';
import '../../models/restaurant.dart';
import '../../providers/admin_provider.dart';
import '../../widgets/admin_drawer.dart';

class AdminRestaurantsScreen extends ConsumerStatefulWidget {
  const AdminRestaurantsScreen({super.key});

  @override
  ConsumerState<AdminRestaurantsScreen> createState() =>
      _AdminRestaurantsScreenState();
}

class _AdminRestaurantsScreenState
    extends ConsumerState<AdminRestaurantsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminRestaurantsProvider.notifier).loadRestaurants();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminRestaurantsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AdminDrawer(currentRoute: '/admin/restaurants'),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Quản lý Quán ăn',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          // Pending badge
          if (state.pendingRestaurants.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${state.pendingRestaurants.length} chờ duyệt',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () {
              ref.read(adminRestaurantsProvider.notifier).loadRestaurants();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Pending Section
          if (state.pendingRestaurants.isNotEmpty)
            _buildPendingSection(state.pendingRestaurants),

          // All Restaurants
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.error != null
                ? Center(child: Text('Lỗi: ${state.error}'))
                : state.restaurants.isEmpty
                ? const Center(child: Text('Không có quán nào'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.restaurants.length,
                    itemBuilder: (context, index) {
                      final restaurant = state.restaurants[index];
                      if (restaurant.status == 'PENDING') {
                        return const SizedBox.shrink();
                      }
                      return _RestaurantCard(
                        restaurant: restaurant,
                        onApprove: restaurant.status == 'PENDING'
                            ? () => _approveRestaurant(restaurant.id!)
                            : null,
                        onReject: restaurant.status == 'PENDING'
                            ? () => _rejectRestaurant(restaurant.id!)
                            : null,
                        onLock: restaurant.status == 'APPROVED'
                            ? () => _lockRestaurant(restaurant.id!)
                            : null,
                        onUnlock: restaurant.status == 'SUSPENDED'
                            ? () => _unlockRestaurant(restaurant.id!)
                            : null,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingSection(List<Restaurant> pendingRestaurants) {
    return Container(
      color: Colors.orange[50],
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chờ duyệt',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 12),
          ...pendingRestaurants.map(
            (r) => _RestaurantCard(
              restaurant: r,
              isPending: true,
              onApprove: () => _approveRestaurant(r.id!),
              onReject: () => _rejectRestaurant(r.id!),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _approveRestaurant(int id) async {
    final success = await ref
        .read(adminRestaurantsProvider.notifier)
        .approveRestaurant(id);
    if (success && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã duyệt quán')));
    }
  }

  Future<void> _rejectRestaurant(int id) async {
    final success = await ref
        .read(adminRestaurantsProvider.notifier)
        .rejectRestaurant(id);
    if (success && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã từ chối quán')));
    }
  }

  Future<void> _lockRestaurant(int id) async {
    final success = await ref
        .read(adminRestaurantsProvider.notifier)
        .lockRestaurant(id);
    if (success && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã khóa quán')));
    }
  }

  Future<void> _unlockRestaurant(int id) async {
    final success = await ref
        .read(adminRestaurantsProvider.notifier)
        .unlockRestaurant(id);
    if (success && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã mở khóa quán')));
    }
  }
}

class _RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final bool isPending;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final VoidCallback? onLock;
  final VoidCallback? onUnlock;

  const _RestaurantCard({
    required this.restaurant,
    this.isPending = false,
    this.onApprove,
    this.onReject,
    this.onLock,
    this.onUnlock,
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
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        restaurant.name ?? 'Không tên',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        restaurant.address ?? 'Không có địa chỉ',
                        style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(restaurant.status ?? 'PENDING'),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  restaurant.isOpen == true
                      ? Icons.circle
                      : Icons.circle_outlined,
                  color: restaurant.isOpen == true ? Colors.green : Colors.grey,
                  size: 12,
                ),
                const SizedBox(width: 4),
                Text(
                  restaurant.isOpen == true ? 'Đang mở' : 'Đang đóng',
                  style: TextStyle(
                    color: restaurant.isOpen == true
                        ? Colors.green
                        : Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            if (isPending ||
                onApprove != null ||
                onLock != null ||
                onUnlock != null) ...[
              const Divider(),
              Row(
                children: [
                  if (onApprove != null)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onApprove,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text('Duyệt'),
                      ),
                    ),
                  if (onApprove != null && onReject != null)
                    const SizedBox(width: 8),
                  if (onReject != null)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onReject,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                        ),
                        child: const Text('Từ chối'),
                      ),
                    ),
                  if (onLock != null)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onLock,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        child: const Text('Khóa'),
                      ),
                    ),
                  if (onUnlock != null)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: onUnlock,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text('Mở khóa'),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;

    switch (status) {
      case 'APPROVED':
        color = Colors.green;
        label = 'Đã duyệt';
        break;
      case 'PENDING':
        color = Colors.orange;
        label = 'Chờ duyệt';
        break;
      case 'REJECTED':
        color = Colors.red;
        label = 'Từ chối';
        break;
      case 'SUSPENDED':
        color = Colors.grey;
        label = 'Bị khóa';
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(26),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

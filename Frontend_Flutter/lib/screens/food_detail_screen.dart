// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/colors.dart';
import '../models/menu_item.dart';
import '../providers/cart_provider.dart';
import '../providers/favorite_provider.dart';
import '../providers/auth_provider.dart';
import '../utils/image_utils.dart';

class FoodDetailScreen extends ConsumerStatefulWidget {
  final MenuItem menuItem;

  const FoodDetailScreen({super.key, required this.menuItem});

  @override
  ConsumerState<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends ConsumerState<FoodDetailScreen> {
  int _quantity = 1;
  bool _isAdding = false;
  bool _isFavoriteLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFavorites();
    });
  }

  Future<void> _loadFavorites() async {
    final userId = ref.read(authProvider).userId;
    if (userId != null) {
      await ref.read(favoriteProvider.notifier).loadFavorites(userId);
    }
  }

  Future<void> _addToCart() async {
    if (_isAdding) return;
    setState(() => _isAdding = true);

    try {
      await ref
          .read(cartProvider.notifier)
          .addToCart(widget.menuItem.id!, _quantity);
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã thêm vào giỏ hàng')));
      Navigator.pop(context);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    } finally {
      if (mounted) {
        setState(() => _isAdding = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.menuItem;
    final price = item.discountPrice != null && item.discountPrice! > 0
        ? item.discountPrice!
        : item.price;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              ImageUtils.buildImageUrl(item.image).isNotEmpty
                  ? ImageUtils.buildImageUrl(item.image)
                  : 'https://via.placeholder.com/800x600',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[300],
                child: const Center(
                  child: Icon(Icons.image_not_supported, size: 64),
                ),
              ),
            ),
          ),
          Positioned.fill(child: Container(color: Colors.black.withAlpha(110))),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      const Spacer(),
                      _buildFavoriteButton()
                    ],
                  ),
                ),
                const Spacer(),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          if (item.categoryName != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                item.categoryName!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          const SizedBox(width: 8),
                          if (item.status != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: item.status == 'AVAILABLE'
                                    ? Colors.green.withOpacity(0.1)
                                    : Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    item.status == 'AVAILABLE'
                                        ? Icons.check_circle
                                        : Icons.cancel,
                                    size: 14,
                                    color: item.status == 'AVAILABLE'
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    item.status == 'AVAILABLE'
                                        ? 'Còn hàng'
                                        : 'Hết hàng',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: item.status == 'AVAILABLE'
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (item.restaurantName != null)
                        Row(
                          children: [
                            const Icon(
                              Icons.store,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item.restaurantName!,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 12),
                      Text(
                        item.description ?? 'Chưa có mô tả',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (item.discountPrice != null &&
                                  item.discountPrice! > 0) ...[
                                Text(
                                  '${item.price.toStringAsFixed(0)} đ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[400],
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                const SizedBox(height: 2),
                              ],
                              Text(
                                '${price.toStringAsFixed(0)} đ',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: _quantity > 1
                                    ? () => setState(() => _quantity--)
                                    : null,
                                icon: const Icon(Icons.remove_circle_outline),
                              ),
                              Text(
                                _quantity.toString(),
                                style: const TextStyle(fontSize: 18),
                              ),
                              IconButton(
                                onPressed: () => setState(() => _quantity++),
                                icon: const Icon(Icons.add_circle_outline),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isAdding ? null : _addToCart,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: _isAdding
                              ? const SizedBox(
                                  height: 18,
                                  width: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Thêm vào giỏ hàng'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteButton() {
    final favoriteState = ref.watch(favoriteProvider);
    final isFavorited = favoriteState.favoriteItemIds.contains(widget.menuItem.id);

    return IconButton(
      onPressed: _isFavoriteLoading
          ? null
          : () async {
              final userId = ref.read(authProvider).userId;
              if (userId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Vui lòng đăng nhập để thêm vào yêu thích')),
                );
                return;
              }

              setState(() => _isFavoriteLoading = true);

              try {
                await ref.read(favoriteProvider.notifier).toggleFavorite(
                  userId,
                  widget.menuItem.id!,
                );

                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isFavorited ? 'Đã xóa khỏi yêu thích' : 'Đã thêm vào yêu thích',
                    ),
                    duration: const Duration(seconds: 1),
                  ),
                );
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Lỗi: $e')),
                );
              } finally {
                if (mounted) {
                  setState(() => _isFavoriteLoading = false);
                }
              }
            },
      icon: _isFavoriteLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Icon(
              isFavorited ? Icons.favorite : Icons.favorite_border,
              color: isFavorited ? Colors.red : Colors.white,
            ),
    );
  }
}

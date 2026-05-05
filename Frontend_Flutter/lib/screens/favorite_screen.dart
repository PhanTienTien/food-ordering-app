import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/colors.dart';
import '../models/favorite_item.dart';
import '../providers/auth_provider.dart';
import '../providers/favorite_provider.dart';
import '../screens/food_detail_screen.dart';
import '../utils/image_utils.dart';

class FavoriteScreen extends ConsumerStatefulWidget {
  const FavoriteScreen({super.key});

  @override
  ConsumerState<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends ConsumerState<FavoriteScreen> {
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

  Future<void> _removeFavorite(FavoriteItem item) async {
    final userId = ref.read(authProvider).userId;
    final menuItemId = item.menuItem?.id;
    if (userId == null || menuItemId == null) return;
    try {
      await ref.read(favoriteProvider.notifier).toggleFavorite(userId, menuItemId);
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
    final favoriteState = ref.watch(favoriteProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Favorite", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadFavorites,
          ),
        ],
      ),
      body: favoriteState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : favoriteState.favorites.isEmpty
          ? _emptyState()
          : RefreshIndicator(
              onRefresh: _loadFavorites,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: favoriteState.favorites.length,
                itemBuilder: (context, index) {
                  return _favoriteItem(favoriteState.favorites[index]);
                },
              ),
            ),
    );
  }

  Widget _favoriteItem(FavoriteItem item) {
    final menuItem = item.menuItem;
    if (menuItem == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FoodDetailScreen(menuItem: menuItem),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(16),
              ),
              child: Image.network(
                ImageUtils.buildImageUrl(menuItem.image).isNotEmpty
                    ? ImageUtils.buildImageUrl(menuItem.image)
                    : 'https://via.placeholder.com/100',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      menuItem.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${menuItem.price.toStringAsFixed(0)} đ',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: () => _removeFavorite(item),
              icon: const Icon(Icons.favorite, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 80, color: Colors.grey),
          SizedBox(height: 10),
          Text("No favorites yet"),
        ],
      ),
    );
  }
}

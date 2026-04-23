import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/colors.dart';
import '../models/favorite_item.dart';
import '../providers/auth_provider.dart';
import '../services/favorite_service.dart';

class FavoriteScreen extends ConsumerStatefulWidget {
  const FavoriteScreen({super.key});

  @override
  ConsumerState<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends ConsumerState<FavoriteScreen> {
  final FavoriteService _favoriteService = FavoriteService();
  List<FavoriteItem> favorites = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final userId = ref.read(authProvider).userId;
      if (userId == null) {
        throw Exception('Missing user id');
      }
      final loaded = await _favoriteService.getFavoritesByUser(userId);
      setState(() {
        favorites = loaded;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> _removeFavorite(FavoriteItem item) async {
    final userId = ref.read(authProvider).userId;
    final menuItemId = item.menuItem?.id;
    if (userId == null || menuItemId == null) return;
    try {
      await _favoriteService.removeFavorite(userId, menuItemId);
      await _loadFavorites();
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
        title: const Text("Favorite", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadFavorites,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : favorites.isEmpty
          ? _emptyState()
          : RefreshIndicator(
              onRefresh: _loadFavorites,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  return _favoriteItem(favorites[index]);
                },
              ),
            ),
    );
  }

  Widget _favoriteItem(FavoriteItem item) {
    final menuItem = item.menuItem;
    return Container(
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
              menuItem?.image ?? 'https://via.placeholder.com/100',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    menuItem?.name ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${menuItem != null ? menuItem.price.toStringAsFixed(0) : '0'} đ',
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

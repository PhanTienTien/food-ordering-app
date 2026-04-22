import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/favorite_service.dart';

final favoriteServiceProvider = Provider<FavoriteService>((ref) => FavoriteService());

class FavoriteState {
  final bool isLoading;
  final List<dynamic> favorites;
  final Set<int> favoriteItemIds;
  final String? error;

  FavoriteState({
    this.isLoading = false,
    this.favorites = const [],
    this.favoriteItemIds = const {},
    this.error,
  });

  FavoriteState copyWith({
    bool? isLoading,
    List<dynamic>? favorites,
    Set<int>? favoriteItemIds,
    String? error,
  }) {
    return FavoriteState(
      isLoading: isLoading ?? this.isLoading,
      favorites: favorites ?? this.favorites,
      favoriteItemIds: favoriteItemIds ?? this.favoriteItemIds,
      error: error,
    );
  }
}

class FavoriteNotifier extends StateNotifier<FavoriteState> {
  final FavoriteService _favoriteService;

  FavoriteNotifier(this._favoriteService) : super(FavoriteState());

  Future<void> loadFavorites(int userId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final favorites = await _favoriteService.getFavoritesByUser(userId);
      final itemIds = favorites.map((f) => f['menuItemId'] as int).toSet();
      state = state.copyWith(
        isLoading: false,
        favorites: favorites,
        favoriteItemIds: itemIds,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> toggleFavorite(int userId, int menuItemId) async {
    try {
      if (state.favoriteItemIds.contains(menuItemId)) {
        await _favoriteService.removeFavorite(userId, menuItemId);
        state.favoriteItemIds.remove(menuItemId);
        state.favorites.removeWhere((f) => f['menuItemId'] == menuItemId);
      } else {
        await _favoriteService.addFavorite(userId, menuItemId);
        state.favoriteItemIds.add(menuItemId);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<bool> checkFavorite(int userId, int menuItemId) async {
    return await _favoriteService.isFavorite(userId, menuItemId);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

final favoriteProvider = StateNotifierProvider<FavoriteNotifier, FavoriteState>((ref) {
  final favoriteService = ref.watch(favoriteServiceProvider);
  return FavoriteNotifier(favoriteService);
});

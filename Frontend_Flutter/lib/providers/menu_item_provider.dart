import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/menu_item.dart';
import '../utils/error_utils.dart';
import '../services/menu_item_service.dart';

// Service Provider
final menuItemServiceProvider = Provider<MenuItemService>(
  (ref) => MenuItemService(),
);

// Menu Item List State
class MenuItemListState {
  final bool isLoading;
  final List<MenuItem> menuItems;
  final String? error;
  final String? searchKeyword;
  final int? selectedCategoryId;
  final int? selectedRestaurantId;

  MenuItemListState({
    this.isLoading = false,
    this.menuItems = const [],
    this.error,
    this.searchKeyword,
    this.selectedCategoryId,
    this.selectedRestaurantId,
  });

  MenuItemListState copyWith({
    bool? isLoading,
    List<MenuItem>? menuItems,
    String? error,
    String? searchKeyword,
    int? selectedCategoryId,
    int? selectedRestaurantId,
  }) {
    return MenuItemListState(
      isLoading: isLoading ?? this.isLoading,
      menuItems: menuItems ?? this.menuItems,
      error: error,
      searchKeyword: searchKeyword ?? this.searchKeyword,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      selectedRestaurantId: selectedRestaurantId ?? this.selectedRestaurantId,
    );
  }
}

// Menu Item Notifier
class MenuItemNotifier extends StateNotifier<MenuItemListState> {
  final MenuItemService _menuItemService;

  MenuItemNotifier(this._menuItemService) : super(MenuItemListState());

  // Load all menu items
  Future<void> loadMenuItems() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final menuItems = await _menuItemService.getAvailableMenuItems();
      state = state.copyWith(isLoading: false, menuItems: menuItems);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: ErrorUtils.message(e));
    }
  }

  // Search menu items
  Future<void> searchMenuItems(String keyword) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      searchKeyword: keyword,
    );

    try {
      final menuItems = await _menuItemService.searchMenuItems(keyword);
      state = state.copyWith(isLoading: false, menuItems: menuItems);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: ErrorUtils.message(e));
    }
  }

  // Filter by category
  Future<void> filterByCategory(int? categoryId) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      selectedCategoryId: categoryId,
    );

    try {
      if (categoryId == null) {
        await loadMenuItems();
        return;
      }
      final menuItems = await _menuItemService.getMenuItemsByCategory(
        categoryId,
      );
      state = state.copyWith(isLoading: false, menuItems: menuItems);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: ErrorUtils.message(e));
    }
  }

  // Filter by restaurant
  Future<void> filterByRestaurant(int? restaurantId) async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      selectedRestaurantId: restaurantId,
    );

    try {
      if (restaurantId == null) {
        await loadMenuItems();
        return;
      }
      final menuItems = await _menuItemService.getMenuItemsByRestaurant(
        restaurantId,
      );
      state = state.copyWith(isLoading: false, menuItems: menuItems);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: ErrorUtils.message(e));
    }
  }

  // Advanced filter
  Future<void> filterMenuItems({
    String? keyword,
    int? restaurantId,
    int? categoryId,
    double? minPrice,
    double? maxPrice,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final menuItems = await _menuItemService.filterMenuItems(
        keyword: keyword,
        restaurantId: restaurantId,
        categoryId: categoryId,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );
      state = state.copyWith(isLoading: false, menuItems: menuItems);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: ErrorUtils.message(e));
    }
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  // Clear filters
  void clearFilters() {
    state = MenuItemListState();
    loadMenuItems();
  }
}

// Menu Item Provider
final menuItemProvider =
    StateNotifierProvider<MenuItemNotifier, MenuItemListState>((ref) {
      final service = ref.watch(menuItemServiceProvider);
      return MenuItemNotifier(service);
    });

// Simple providers
final menuItemsProvider = Provider<List<MenuItem>>((ref) {
  return ref.watch(menuItemProvider).menuItems;
});

final menuItemLoadingProvider = Provider<bool>((ref) {
  return ref.watch(menuItemProvider).isLoading;
});

final menuItemErrorProvider = Provider<String?>((ref) {
  return ref.watch(menuItemProvider).error;
});

final selectedCategoryProvider = Provider<int?>((ref) {
  return ref.watch(menuItemProvider).selectedCategoryId;
});

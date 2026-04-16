import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category.dart';
import '../services/category_service.dart';

// Service Provider
final categoryServiceProvider = Provider<CategoryService>((ref) => CategoryService());

// Category List State
class CategoryListState {
  final bool isLoading;
  final List<Category> categories;
  final String? error;

  CategoryListState({
    this.isLoading = false,
    this.categories = const [],
    this.error,
  });

  CategoryListState copyWith({
    bool? isLoading,
    List<Category>? categories,
    String? error,
  }) {
    return CategoryListState(
      isLoading: isLoading ?? this.isLoading,
      categories: categories ?? this.categories,
      error: error,
    );
  }
}

// Category Notifier
class CategoryNotifier extends StateNotifier<CategoryListState> {
  final CategoryService _categoryService;

  CategoryNotifier(this._categoryService) : super(CategoryListState());

  // Load all categories
  Future<void> loadCategories() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final categories = await _categoryService.getAllCategories();
      state = state.copyWith(isLoading: false, categories: categories);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Category Provider
final categoryProvider = StateNotifierProvider<CategoryNotifier, CategoryListState>((ref) {
  final service = ref.watch(categoryServiceProvider);
  return CategoryNotifier(service);
});

// Simple providers
final categoriesProvider = Provider<List<Category>>((ref) {
  return ref.watch(categoryProvider).categories;
});

final categoryLoadingProvider = Provider<bool>((ref) {
  return ref.watch(categoryProvider).isLoading;
});

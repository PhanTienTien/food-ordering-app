import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../models/restaurant.dart';
import '../models/category.dart';
import '../utils/error_utils.dart';
import '../services/admin_service.dart';

// Service Provider
final adminServiceProvider = Provider<AdminService>((ref) => AdminService());

// Admin Dashboard State
class AdminDashboardState {
  final bool isLoading;
  final Map<String, dynamic>? summary;
  final String? error;

  AdminDashboardState({this.isLoading = false, this.summary, this.error});

  AdminDashboardState copyWith({
    bool? isLoading,
    Map<String, dynamic>? summary,
    String? error,
  }) {
    return AdminDashboardState(
      isLoading: isLoading ?? this.isLoading,
      summary: summary ?? this.summary,
      error: error,
    );
  }
}

// Admin Users State
class AdminUsersState {
  final bool isLoading;
  final List<User> users;
  final String? error;

  AdminUsersState({this.isLoading = false, this.users = const [], this.error});

  AdminUsersState copyWith({
    bool? isLoading,
    List<User>? users,
    String? error,
  }) {
    return AdminUsersState(
      isLoading: isLoading ?? this.isLoading,
      users: users ?? this.users,
      error: error,
    );
  }
}

// Admin Restaurants State
class AdminRestaurantsState {
  final bool isLoading;
  final List<Restaurant> restaurants;
  final List<Restaurant> pendingRestaurants;
  final String? error;

  AdminRestaurantsState({
    this.isLoading = false,
    this.restaurants = const [],
    this.pendingRestaurants = const [],
    this.error,
  });

  AdminRestaurantsState copyWith({
    bool? isLoading,
    List<Restaurant>? restaurants,
    List<Restaurant>? pendingRestaurants,
    String? error,
  }) {
    return AdminRestaurantsState(
      isLoading: isLoading ?? this.isLoading,
      restaurants: restaurants ?? this.restaurants,
      pendingRestaurants: pendingRestaurants ?? this.pendingRestaurants,
      error: error,
    );
  }
}

// Admin Categories State
class AdminCategoriesState {
  final bool isLoading;
  final List<Category> categories;
  final String? error;

  AdminCategoriesState({
    this.isLoading = false,
    this.categories = const [],
    this.error,
  });

  AdminCategoriesState copyWith({
    bool? isLoading,
    List<Category>? categories,
    String? error,
  }) {
    return AdminCategoriesState(
      isLoading: isLoading ?? this.isLoading,
      categories: categories ?? this.categories,
      error: error,
    );
  }
}

// Dashboard Notifier
class AdminDashboardNotifier extends StateNotifier<AdminDashboardState> {
  final AdminService _adminService;

  AdminDashboardNotifier(this._adminService) : super(AdminDashboardState());

  Future<void> loadDashboard() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final summary = await _adminService.getDashboardSummary();
      state = state.copyWith(isLoading: false, summary: summary);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: ErrorUtils.message(e));
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Users Notifier
class AdminUsersNotifier extends StateNotifier<AdminUsersState> {
  final AdminService _adminService;

  AdminUsersNotifier(this._adminService) : super(AdminUsersState());

  Future<void> loadUsers() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final users = await _adminService.getAllUsers();
      state = state.copyWith(isLoading: false, users: users);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: ErrorUtils.message(e));
    }
  }

  Future<bool> lockUser(int userId) async {
    try {
      await _adminService.lockUser(userId);
      await loadUsers();
      return true;
    } catch (e) {
      state = state.copyWith(error: ErrorUtils.message(e));
      return false;
    }
  }

  Future<bool> unlockUser(int userId) async {
    try {
      await _adminService.unlockUser(userId);
      await loadUsers();
      return true;
    } catch (e) {
      state = state.copyWith(error: ErrorUtils.message(e));
      return false;
    }
  }

  Future<bool> deleteUser(int userId) async {
    try {
      await _adminService.deleteUser(userId);
      await loadUsers();
      return true;
    } catch (e) {
      state = state.copyWith(error: ErrorUtils.message(e));
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  Future<bool> createStaffUser({
    required String name,
    required String email,
    required String password,
    required int restaurantId,
  }) async {
    try {
      await _adminService.createStaffUser(
        name: name,
        email: email,
        password: password,
        restaurantId: restaurantId,
      );
      await loadUsers();
      return true;
    } catch (e) {
      state = state.copyWith(error: ErrorUtils.message(e));
      return false;
    }
  }
}

// Restaurants Notifier
class AdminRestaurantsNotifier extends StateNotifier<AdminRestaurantsState> {
  final AdminService _adminService;

  AdminRestaurantsNotifier(this._adminService) : super(AdminRestaurantsState());

  Future<void> loadRestaurants() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final restaurants = await _adminService.getAllRestaurants();
      final pending = await _adminService.getPendingRestaurants();
      state = state.copyWith(
        isLoading: false,
        restaurants: restaurants,
        pendingRestaurants: pending,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: ErrorUtils.message(e));
    }
  }

  Future<bool> approveRestaurant(int id) async {
    try {
      await _adminService.approveRestaurant(id);
      await loadRestaurants();
      return true;
    } catch (e) {
      state = state.copyWith(error: ErrorUtils.message(e));
      return false;
    }
  }

  Future<bool> rejectRestaurant(int id) async {
    try {
      await _adminService.rejectRestaurant(id);
      await loadRestaurants();
      return true;
    } catch (e) {
      state = state.copyWith(error: ErrorUtils.message(e));
      return false;
    }
  }

  Future<bool> lockRestaurant(int id) async {
    try {
      await _adminService.lockRestaurant(id);
      await loadRestaurants();
      return true;
    } catch (e) {
      state = state.copyWith(error: ErrorUtils.message(e));
      return false;
    }
  }

  Future<bool> unlockRestaurant(int id) async {
    try {
      await _adminService.unlockRestaurant(id);
      await loadRestaurants();
      return true;
    } catch (e) {
      state = state.copyWith(error: ErrorUtils.message(e));
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  Future<bool> createRestaurant({
    required String name,
    required String address,
    String? phone,
    String? image,
    String? description,
    double? latitude,
    double? longitude,
    double? deliveryRadius,
    double? commissionRate,
  }) async {
    try {
      await _adminService.createRestaurant(
        name: name,
        address: address,
        phone: phone,
        image: image,
        description: description,
        latitude: latitude,
        longitude: longitude,
        deliveryRadius: deliveryRadius,
        commissionRate: commissionRate,
      );
      await loadRestaurants();
      return true;
    } catch (e) {
      state = state.copyWith(error: ErrorUtils.message(e));
      return false;
    }
  }
}

// Categories Notifier
class AdminCategoriesNotifier extends StateNotifier<AdminCategoriesState> {
  final AdminService _adminService;

  AdminCategoriesNotifier(this._adminService) : super(AdminCategoriesState());

  Future<void> loadCategories() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final categories = await _adminService.getAllCategories();
      state = state.copyWith(isLoading: false, categories: categories);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: ErrorUtils.message(e));
    }
  }

  Future<bool> createCategory(String name, {String? image}) async {
    try {
      await _adminService.createCategory(name, image: image);
      await loadCategories();
      return true;
    } catch (e) {
      state = state.copyWith(error: ErrorUtils.message(e));
      return false;
    }
  }

  Future<bool> updateCategory(int id, String name, {String? image}) async {
    try {
      await _adminService.updateCategory(id, name, image: image);
      await loadCategories();
      return true;
    } catch (e) {
      state = state.copyWith(error: ErrorUtils.message(e));
      return false;
    }
  }

  Future<bool> deleteCategory(int id) async {
    try {
      await _adminService.deleteCategory(id);
      await loadCategories();
      return true;
    } catch (e) {
      state = state.copyWith(error: ErrorUtils.message(e));
      return false;
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Providers
final adminDashboardProvider =
    StateNotifierProvider<AdminDashboardNotifier, AdminDashboardState>((ref) {
      final service = ref.watch(adminServiceProvider);
      return AdminDashboardNotifier(service);
    });

final adminUsersProvider =
    StateNotifierProvider<AdminUsersNotifier, AdminUsersState>((ref) {
      final service = ref.watch(adminServiceProvider);
      return AdminUsersNotifier(service);
    });

final adminRestaurantsProvider =
    StateNotifierProvider<AdminRestaurantsNotifier, AdminRestaurantsState>((
      ref,
    ) {
      final service = ref.watch(adminServiceProvider);
      return AdminRestaurantsNotifier(service);
    });

final adminCategoriesProvider =
    StateNotifierProvider<AdminCategoriesNotifier, AdminCategoriesState>((ref) {
      final service = ref.watch(adminServiceProvider);
      return AdminCategoriesNotifier(service);
    });

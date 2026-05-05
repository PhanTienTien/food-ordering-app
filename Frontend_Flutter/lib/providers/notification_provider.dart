import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/notification_service.dart';

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService(),
);

class NotificationState {
  final int unreadCount;
  final bool isLoading;
  final String? error;

  const NotificationState({
    this.unreadCount = 0,
    this.isLoading = false,
    this.error,
  });

  NotificationState copyWith({
    int? unreadCount,
    bool? isLoading,
    String? error,
  }) {
    return NotificationState(
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class NotificationNotifier extends StateNotifier<NotificationState> {
  final NotificationService _notificationService;

  NotificationNotifier(this._notificationService)
      : super(const NotificationState());

  Future<void> loadUnreadCount(int userId) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final count = await _notificationService.getUnreadCount(userId);
      state = state.copyWith(unreadCount: count, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void decrementCount() {
    if (state.unreadCount > 0) {
      state = state.copyWith(unreadCount: state.unreadCount - 1);
    }
  }

  void clearCount() {
    state = state.copyWith(unreadCount: 0);
  }

  void refreshCount(int userId) async {
    await loadUnreadCount(userId);
  }
}

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  final notificationService = ref.watch(notificationServiceProvider);
  return NotificationNotifier(notificationService);
});

final unreadCountProvider = Provider<int>((ref) {
  return ref.watch(notificationProvider).unreadCount;
});

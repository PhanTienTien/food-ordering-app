import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'role_utils.dart';

class TokenStorage {
  static const String _tokenKey = 'jwt_token';
  static const String _userIdKey = 'user_id';
  static const String _userRoleKey = 'user_role';
  static const String _restaurantIdKey = 'restaurant_id';

  static Future<SharedPreferences> _prefs() {
    return SharedPreferences.getInstance();
  }

  static Future<void> saveToken(String token) async {
    final prefs = await _prefs();
    await prefs.setString(_tokenKey, token);

    final claims = _decodeJwtPayload(token);
    final userId = _readUserId(claims?['sub']);
    final role = normalizeRole(claims?['role']?.toString());
    final restaurantId = _readUserId(claims?['restaurantId']);

    if (userId != null && role != null && role.isNotEmpty) {
      await saveUserInfo(
        userId: userId,
        role: role,
        restaurantId: restaurantId,
      );
    }
  }

  static Future<String?> getToken() async {
    final prefs = await _prefs();
    return prefs.getString(_tokenKey);
  }

  static Future<void> clearToken() async {
    final prefs = await _prefs();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userRoleKey);
    await prefs.remove(_restaurantIdKey);
  }

  static Future<void> saveUserInfo({
    required int userId,
    required String role,
    int? restaurantId,
  }) async {
    final prefs = await _prefs();
    await prefs.setInt(_userIdKey, userId);
    await prefs.setString(_userRoleKey, role);
    if (restaurantId != null) {
      await prefs.setInt(_restaurantIdKey, restaurantId);
    } else {
      await prefs.remove(_restaurantIdKey);
    }
  }

  static Future<int?> getUserId() async {
    final prefs = await _prefs();
    return prefs.getInt(_userIdKey);
  }

  static Future<int> requireUserId() async {
    final userId = await getUserId();
    if (userId == null) {
      throw const FormatException('User not logged in');
    }
    return userId;
  }

  static Future<String?> getUserRole() async {
    final prefs = await _prefs();
    return prefs.getString(_userRoleKey);
  }

  static Future<int?> getRestaurantId() async {
    final prefs = await _prefs();
    return prefs.getInt(_restaurantIdKey);
  }

  static int? _readUserId(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }

  static Map<String, dynamic>? _decodeJwtPayload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      return null;
    }

    try {
      final payload = base64Url.normalize(parts[1]);
      final decoded = utf8.decode(base64Url.decode(payload));
      final jsonMap = jsonDecode(decoded);
      if (jsonMap is Map<String, dynamic>) {
        return jsonMap;
      }
      if (jsonMap is Map) {
        return Map<String, dynamic>.from(jsonMap);
      }
    } catch (_) {
      return null;
    }
    return null;
  }
}

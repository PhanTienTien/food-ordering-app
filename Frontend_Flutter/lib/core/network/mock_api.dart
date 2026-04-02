import 'dart:async';

class MockApi {
  static Future<List<Map<String, dynamic>>> getRestaurants() async {
    await Future.delayed(const Duration(seconds: 1)); // giả lập network

    return [
      {
        "id": 1,
        "name": "Pizza Hut",
        "rating": 4.5,
      },
      {
        "id": 2,
        "name": "KFC",
        "rating": 4.2,
      },
    ];
  }
}

// SAU NÀY: replace bằng:
// DioClient.instance.get("/restaurants");
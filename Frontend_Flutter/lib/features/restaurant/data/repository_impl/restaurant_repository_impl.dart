import '../../../../core/network/mock_api.dart';
import '../../domain/entities/restaurant.dart';

class RestaurantRepositoryImpl {
  Future<List<Restaurant>> getRestaurants() async {
    final data = await MockApi.getRestaurants();

    return data
        .map((e) => Restaurant(
      id: e["id"],
      name: e["name"],
      rating: (e["rating"] as num).toDouble(),
    ))
        .toList();
  }
}

//Sau này gọi API thật. 
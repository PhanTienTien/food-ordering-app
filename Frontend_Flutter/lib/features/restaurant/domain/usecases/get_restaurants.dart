import '../entities/restaurant.dart';
import '../../data/repository_impl/restaurant_repository_impl.dart';

class GetRestaurants {
  final repo = RestaurantRepositoryImpl();

  Future<List<Restaurant>> call() {
    return repo.getRestaurants();
  }
}
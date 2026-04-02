import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/restaurant.dart';
import '../../domain/usecases/get_restaurants.dart';

final restaurantProvider =
FutureProvider<List<Restaurant>>((ref) async {
  final usecase = GetRestaurants();
  return usecase();
});
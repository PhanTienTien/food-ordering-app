import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/restaurant_provider.dart';

class RestaurantListScreen extends ConsumerWidget {
  const RestaurantListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurantsAsync = ref.watch(restaurantProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Restaurants")),
      body: restaurantsAsync.when(
        data: (restaurants) => ListView.builder(
          itemCount: restaurants.length,
          itemBuilder: (context, index) {
            final r = restaurants[index];
            return ListTile(
              title: Text(r.name),
              subtitle: Text("⭐ ${r.rating}"),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }
}
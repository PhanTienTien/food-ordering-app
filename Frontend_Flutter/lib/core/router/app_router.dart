import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:foodapp/features/restaurant/presentation/screens/restaurant_list_screen.dart';

final appRouter = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const RestaurantListScreen(),
    ),
  ],
);
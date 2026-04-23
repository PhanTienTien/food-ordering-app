import 'package:flutter/material.dart';
import '../screens/cart_screen.dart';
import '../screens/favorite_screen.dart';
import '../screens/home_screen.dart';
import '../screens/order_history_screen.dart';
import '../screens/setting_screen.dart';

class NavEntry {
  final IconData icon;
  final String label;
  final Widget Function() builder;

  const NavEntry({
    required this.icon,
    required this.label,
    required this.builder,
  });
}

const customerTabs = [
  NavEntry(icon: Icons.home, label: 'Home', builder: HomeScreen.new),
  NavEntry(icon: Icons.shopping_cart, label: 'Cart', builder: CartScreen.new),
  NavEntry(
    icon: Icons.favorite,
    label: 'Favorites',
    builder: FavoriteScreen.new,
  ),
  NavEntry(icon: Icons.settings, label: 'Settings', builder: SettingScreen.new),
];

const customerDrawerEntries = [
  NavEntry(icon: Icons.home, label: 'Home', builder: HomeScreen.new),
  NavEntry(icon: Icons.shopping_cart, label: 'Cart', builder: CartScreen.new),
  NavEntry(
    icon: Icons.history,
    label: 'Order history',
    builder: OrderHistoryScreen.new,
  ),
  NavEntry(
    icon: Icons.favorite,
    label: 'Favorite',
    builder: FavoriteScreen.new,
  ),
  NavEntry(icon: Icons.settings, label: 'Settings', builder: SettingScreen.new),
];

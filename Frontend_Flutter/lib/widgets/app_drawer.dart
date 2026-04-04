import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../screens/home_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/favorite_screen.dart';
import '../screens/order_history_screen.dart';
import '../screens/setting_screen.dart';
import '../screens/login_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [

          /// 🔹 HEADER
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: AppColors.primary,
            ),
            accountName: Text("Tien Phan"),
            accountEmail: Text("tienphan@email.com"),
            currentAccountPicture: CircleAvatar(
              backgroundImage:
              NetworkImage("https://i.pravatar.cc/150"),
            ),
          ),

          /// 🔹 MENU ITEMS
          _buildItem(context, Icons.home, "Home", HomeScreen()),
          _buildItem(context, Icons.receipt, "Orders", CartScreen()),
          _buildItem(context, Icons.receipt, "Orders History", OrderHistoryScreen()),
          _buildItem(context, Icons.favorite, "Favorite", FavoriteScreen()),
          _buildItem(context, Icons.settings, "Settings", SettingScreen()),

          Spacer(),

          /// 🔹 LOGOUT
          _buildItem(
            context,
            Icons.logout,
            "Logout",
            LoginScreen(),
            isLogout: true,
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, IconData icon,
      String title, Widget screen,
      {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon,
          color: isLogout ? Colors.red : AppColors.primary),
      title: Text(title),
        onTap: () {
          Navigator.pop(context);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => screen),
          );
        }
    );
  }
}
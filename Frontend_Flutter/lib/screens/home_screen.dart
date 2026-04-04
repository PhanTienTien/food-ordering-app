import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/app_drawer.dart';
import '../widgets/home_header.dart';
import '../widgets/category_list.dart';
import '../widgets/food_card.dart';
import '../widgets/notification_bell.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: AppDrawer(),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        /// 🔹 MENU ICON
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),

        /// 🔹 NOTIFICATION ICON
        actions: [
          NotificationBell(count: 3),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            HomeHeader(),

            SizedBox(height: 16),

            CategoryList(),

            SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Hot Deals 🔥",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("See All",
                      style: TextStyle(color: AppColors.primary)),
                ],
              ),
            ),

            SizedBox(height: 12),

            Expanded(
              child: GridView.count(
                padding: EdgeInsets.all(16),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
                children: [
                  FoodCard(),
                  FoodCard(),
                ],
              ),
            ),
          ],
        ),
      ),


    );
  }
}
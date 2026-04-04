import 'package:flutter/material.dart';
import '../constants/colors.dart';

class FavoriteScreen extends StatelessWidget {

  /// 🔥 Fake data (sau này thay bằng API)
  final List<Map<String, String>> favorites = [
    {
      "title": "Burger Beef",
      "price": "\$12.00",
      "image":
      "https://images.unsplash.com/photo-1568901346375-23c9450c58cd"
    },
    {
      "title": "Pizza Cheese",
      "price": "\$15.00",
      "image":
      "https://images.unsplash.com/photo-1548365328-9f547fb0953d"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Favorite",
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),

      body: favorites.isEmpty
          ? _emptyState()
          : ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final item = favorites[index];
          return _favoriteItem(item);
        },
      ),
    );
  }

  /// 🔹 ITEM CARD
  Widget _favoriteItem(Map<String, String> item) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5),
        ],
      ),
      child: Row(
        children: [

          /// 🔹 IMAGE
          ClipRRect(
            borderRadius: BorderRadius.horizontal(
                left: Radius.circular(16)),
            child: Image.network(
              item["image"]!,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),

          /// 🔹 INFO
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(item["title"]!,
                      style: TextStyle(
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 5),
                  Text(item["price"]!,
                      style: TextStyle(
                          color: AppColors.primary)),
                ],
              ),
            ),
          ),

          /// ❤️ REMOVE FAVORITE
          IconButton(
            onPressed: () {
              // TODO: remove favorite
            },
            icon: Icon(Icons.favorite, color: Colors.red),
          )
        ],
      ),
    );
  }

  /// 🔹 EMPTY UI
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border,
              size: 80, color: Colors.grey),
          SizedBox(height: 10),
          Text("No favorites yet"),
        ],
      ),
    );
  }
}
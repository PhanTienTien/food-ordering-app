import 'package:flutter/material.dart';
import '../screens/food_detail_screen.dart';

class FoodCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => FoodDetailScreen(),
          ),
        );
      },

      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 5),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
              BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                "https://images.unsplash.com/photo-1550547660-d9450f859349",
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text("Delicious Food",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text("\$9.67",
                  style: TextStyle(color: Colors.orange)),
            ),
          ],
        ),
      ),
    );
  }
}
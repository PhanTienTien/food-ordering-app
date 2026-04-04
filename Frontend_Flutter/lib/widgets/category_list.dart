import 'package:flutter/material.dart';
import '../constants/colors.dart';

class CategoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<String> categories = ["Meals", "Dinners", "Drinks"];

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(left: 16),
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: index == 0 ? AppColors.primary : Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: Text(
              categories[index],
              style: TextStyle(
                color: index == 0 ? Colors.white : Colors.black,
              ),
            ),
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../constants/colors.dart';

class CartItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final String image;

  const CartItem({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5),
        ],
      ),

      child: Row(
        children: [

          /// IMAGE
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(image),
          ),

          SizedBox(width: 12),

          /// INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(subtitle,
                    style: TextStyle(color: Colors.grey)),
                SizedBox(height: 6),
                Text(price,
                    style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          /// QUANTITY
          Row(
            children: [
              _qtyButton(Icons.remove),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text("5"),
              ),
              _qtyButton(Icons.add),
            ],
          )
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon) {
    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.orange.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 16, color: Colors.orange),
    );
  }
}
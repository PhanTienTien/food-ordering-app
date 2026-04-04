import 'package:flutter/material.dart';
import '../constants/colors.dart';

class FoodDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // 🔹 1. Cho phép body tràn lên dưới AppBar để thấy ảnh nền
      extendBodyBehindAppBar: true,

      // 🔹 2. Thêm AppBar giống trong ảnh mẫu nhưng làm trong suốt
      appBar: AppBar(
        title: const Text(
          "Order Detail", // Sửa text theo ảnh mẫu của bạn
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: const BackButton(color: Colors.white),
        backgroundColor: Colors.transparent, // Giữ độ trong suốt để thấy ảnh nền
        elevation: 0, // Xóa bóng đổ
        centerTitle: true,
        actions: [
          // Giữ lại nút yêu thích cũ của bạn nhưng chuyển vào actions
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 18,
              child: Icon(Icons.favorite_border, color: Colors.black, size: 20),
            ),
          ),
        ],
      ),

      body: Stack(
        children: [
          /// 🔹 BACKGROUND HEADER
          Container(
            height: 280,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    "https://images.unsplash.com/photo-1504674900247-0877df9cc836"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// 🔹 MAIN CONTENT
          Positioned.fill(
            top: 200,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  SizedBox(height: 60),

                  /// TITLE
                  Text(
                    "Fried grill noodles with egg special",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 12),

                  /// INFO ROW
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Icon(Icons.star, color: Colors.orange, size: 16),
                        SizedBox(width: 4),
                        Text("4.8"),
                      ]),
                      Row(children: [
                        Icon(Icons.local_fire_department,
                            color: Colors.orange, size: 16),
                        SizedBox(width: 4),
                        Text("124 Kcal"),
                      ]),
                      Row(children: [
                        Icon(Icons.access_time,
                            color: Colors.orange, size: 16),
                        SizedBox(width: 4),
                        Text("15 min"),
                      ]),
                    ],
                  ),

                  SizedBox(height: 16),

                  /// DESCRIPTION
                  Text("Description",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text(
                    "Vegetable noodles is a healthy Chinese inspired dish...",
                    style: TextStyle(color: Colors.grey),
                  ),

                  SizedBox(height: 16),

                  /// LOCATION
                  Text("Location",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),

                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(
                            "https://maps.gstatic.com/tactile/basepage/pegman_sherlock.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  Spacer(),

                  /// PRICE + BUTTON
                  Row(
                    children: [
                      Text("\$35.25",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                      SizedBox(width: 16),

                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              "Add to Cart",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),

          /// 🔹 FOOD IMAGE (OVERLAY)
          Positioned(
            top: 140,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 10)
                  ],
                  image: DecorationImage(
                    image: NetworkImage(
                        "https://images.unsplash.com/photo-1604908176997-431c9b9d91e3"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
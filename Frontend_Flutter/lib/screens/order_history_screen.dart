import 'package:flutter/material.dart';
import '../constants/colors.dart';

class OrderHistoryScreen extends StatelessWidget {

  final List<Map<String, dynamic>> orders = [
    {
      "id": "#1234",
      "status": "Delivered",
      "total": "\$25.00",
      "date": "12 Apr 2026"
    },
    {
      "id": "#5678",
      "status": "Preparing",
      "total": "\$40.00",
      "date": "13 Apr 2026"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text("Orders",
            style: TextStyle(color: Colors.black)),
        leading: BackButton(),
        centerTitle: true,
      ),

      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return _orderItem(order);
        },
      ),
    );
  }

  Widget _orderItem(Map<String, dynamic> order) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔹 TOP
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              Text(order["id"],
                  style: TextStyle(
                      fontWeight: FontWeight.bold)),
              Text(order["status"],
                  style: TextStyle(
                    color: order["status"] == "Delivered"
                        ? Colors.green
                        : AppColors.primary,
                  )),
            ],
          ),

          SizedBox(height: 10),

          /// 🔹 INFO
          Text("Date: ${order["date"]}"),
          Text("Total: ${order["total"]}"),

          SizedBox(height: 10),

          /// 🔹 BUTTON
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // TODO: xem chi tiết
              },
              child: Text("View Detail"),
            ),
          )
        ],
      ),
    );
  }
}
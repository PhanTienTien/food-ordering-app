import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/order_item.dart';

class PaymentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,


      body: Column(
        children: [

          /// 🔹 HEADER
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.arrow_back),
                  SizedBox(width: 12),
                  Text(
                    "Payment",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

          /// 🔹 BODY
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [

                  /// DELIVERY INFO
                  _sectionCard(
                    child: Row(
                      children: [
                        Icon(Icons.location_on,
                            color: AppColors.primary),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text("Hong Ngoc",
                                  style: TextStyle(
                                      fontWeight:
                                      FontWeight.bold)),
                              Text("84 Phuc Dien Street...",
                                  style: TextStyle(
                                      color: Colors.grey)),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  SizedBox(height: 12),

                  /// ORDER LIST
                  _sectionCard(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text("Your Order",
                            style: TextStyle(
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        OrderItem(
                            title:
                            "1x Beef Pizza with fried citronella",
                            price: "55.000đ"),
                        OrderItem(
                            title:
                            "1x Pork’s Kidneys and heart rice gruel",
                            price: "35.000đ"),
                      ],
                    ),
                  ),

                  SizedBox(height: 12),

                  /// VOUCHER
                  _sectionCard(
                    child: Row(
                      children: [
                        Icon(Icons.local_offer,
                            color: AppColors.primary),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "30K discount for orders from 40K",
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios, size: 14)
                      ],
                    ),
                  ),

                  SizedBox(height: 12),

                  /// SUMMARY
                  _sectionCard(
                    child: Column(
                      children: [
                        _summaryRow("Subtotal", "90.000đ"),
                        _summaryRow("Shipping Fee", "30.000đ"),
                        _summaryRow("Voucher", "-30.000đ",
                            color: Colors.red),
                        Divider(),
                        _summaryRow("Total", "90.000đ",
                            isBold: true),
                      ],
                    ),
                  ),

                  Spacer(),

                  /// PAYMENT METHOD
                  Row(
                    children: [
                      Expanded(
                        child: _paymentMethod(
                            "Card", false),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: _paymentMethod(
                            "Cash", true),
                      ),
                    ],
                  ),

                  SizedBox(height: 12),

                  /// CHECKOUT BUTTON
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "Check out",
                        style: TextStyle(
                            color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// 🔹 CARD WRAPPER
  Widget _sectionCard({required Widget child}) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5),
        ],
      ),
      child: child,
    );
  }

  /// 🔹 SUMMARY ROW
  Widget _summaryRow(String title, String value,
      {Color? color, bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            value,
            style: TextStyle(
              color: color ?? Colors.black,
              fontWeight:
              isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 PAYMENT METHOD
  Widget _paymentMethod(String title, bool selected) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: selected
            ? AppColors.primary.withOpacity(0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected
              ? AppColors.primary
              : Colors.grey.shade300,
        ),
      ),
      child: Center(
        child: Text(title),
      ),
    );
  }
}
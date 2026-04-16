import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../widgets/app_header.dart';
import '../widgets/cart_item.dart';
import 'payment_screen.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppHeader(
        title: "Cart",
        showBack: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Expanded(child: _CartList()),
                  const _Summary(),
                  const SizedBox(height: 16),
                  _CheckoutButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartList extends StatelessWidget {
  const _CartList();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        CartItem(
          title: "Chicken Noodles",
          subtitle: "Mince Dish",
          price: "\$50.00",
          image:
          "https://images.unsplash.com/photo-1604908176997-431c9b9d91e3",
        ),
        CartItem(
          title: "Drawing Food",
          subtitle: "Salad",
          price: "\$50.00",
          image:
          "https://images.unsplash.com/photo-1546069901-ba9599a7e63c",
        ),
        CartItem(
          title: "Chicken Noodles",
          subtitle: "Mince Dish",
          price: "\$50.00",
          image:
          "https://images.unsplash.com/photo-1604908176997-431c9b9d91e3",
        ),
      ],
    );
  }
}

//
// 🔹 SUMMARY
//
class _Summary extends StatelessWidget {
  const _Summary();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _SummaryRow("Subtotal", "\$435.00"),
        _SummaryRow("Discount", "30%"),
        _SummaryRow("Shipping", "-\$11.00", color: Colors.red),
        Divider(),
        _SummaryRow("Total", "\$678.00", isBold: true),
      ],
    );
  }
}

//
// 🔹 SUMMARY ROW (REUSABLE)
//
class _SummaryRow extends StatelessWidget {
  final String title;
  final String value;
  final Color? color;
  final bool isBold;

  const _SummaryRow(
      this.title,
      this.value, {
        this.color,
        this.isBold = false,
      });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
}

//
// 🔹 CHECKOUT BUTTON
//
class _CheckoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentScreen(),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            "Proceed To Checkout",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
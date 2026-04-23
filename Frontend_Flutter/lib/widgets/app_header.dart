import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;
  final Widget? right;

  const AppHeader({
    super.key,
    required this.title,
    this.showBack = false,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// 🔙 BACK
          showBack
              ? GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back, color: Colors.white),
                )
              : SizedBox(width: 24),

          /// 🔹 TITLE
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          /// 🔹 RIGHT ICON
          right ?? SizedBox(width: 24),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(100);
}

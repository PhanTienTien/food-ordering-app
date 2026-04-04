import 'package:flutter/material.dart';

class AppNavigator {
  static void push(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 300),

        pageBuilder: (_, __, ___) => screen,

        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween(
              begin: Offset(1, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            )),
            child: child,
          );
        },
      ),
    );
  }
}
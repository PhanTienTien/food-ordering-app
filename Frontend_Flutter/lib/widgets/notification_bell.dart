import 'package:flutter/material.dart';

class NotificationBell extends StatefulWidget {
  final int count;

  const NotificationBell({super.key, this.count = 0});

  @override
  State<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    /// 🔹 Animation rung
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _animation = Tween<double>(begin: -0.1, end: 0.1)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(_controller);

    /// auto rung khi có notification
    if (widget.count > 0) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        // TODO: mở màn notification
      },
      icon: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _animation.value,
            child: child,
          );
        },

        child: Stack(
          children: [

            /// 🔔 ICON
            const Icon(Icons.notifications_none, color: Colors.black),

            /// 🔴 BADGE
            if (widget.count > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    widget.count > 9 ? "9+" : "${widget.count}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
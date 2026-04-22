import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/colors.dart';
import '../models/topping.dart';
import '../services/topping_service.dart';

class ToppingSelector extends ConsumerStatefulWidget {
  final int restaurantId;
  final Map<int, int> selectedToppings;
  final Function(Map<int, int>) onToppingsChanged;

  const ToppingSelector({
    required this.restaurantId,
    required this.selectedToppings,
    required this.onToppingsChanged,
    super.key,
  });

  @override
  ConsumerState<ToppingSelector> createState() => _ToppingSelectorState();
}

class _ToppingSelectorState extends ConsumerState<ToppingSelector> {
  final ToppingService _toppingService = ToppingService();
  List<Topping> toppings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadToppings();
  }

  Future<void> _loadToppings() async {
    try {
      final loaded = await _toppingService.getAvailableToppingsByRestaurant(widget.restaurantId);
      setState(() {
        toppings = loaded;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _updateToppingQuantity(Topping topping, int delta) {
    final newQuantity = (widget.selectedToppings[topping.id] ?? 0) + delta;
    if (newQuantity < 0) return;

    final updated = Map<int, int>.from(widget.selectedToppings);
    if (newQuantity == 0) {
      updated.remove(topping.id);
    } else {
      updated[topping.id!] = newQuantity;
    }
    widget.onToppingsChanged(updated);
  }

  double _calculateToppingTotal() {
    double total = 0;
    widget.selectedToppings.forEach((toppingId, quantity) {
      final topping = toppings.firstWhere((t) => t.id == toppingId);
      total += (topping.price ?? 0) * quantity;
    });
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade200),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Thêm topping',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          // Topping list
          isLoading
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                )
              : toppings.isEmpty
                  ? Padding(
                      padding: EdgeInsets.all(32),
                      child: Text('Không có topping nào'),
                    )
                  : Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: toppings.length,
                        itemBuilder: (context, index) {
                          final topping = toppings[index];
                          final quantity = widget.selectedToppings[topping.id] ?? 0;
                          return _ToppingItem(
                            topping: topping,
                            quantity: quantity,
                            onIncrement: () => _updateToppingQuantity(topping, 1),
                            onDecrement: () => _updateToppingQuantity(topping, -1),
                          );
                        },
                      ),
                    ),
          // Footer with total
          if (widget.selectedToppings.isNotEmpty)
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tổng cộng topping',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        '${_calculateToppingTotal().toStringAsFixed(0)}đ',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Xác nhận'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ToppingItem extends StatelessWidget {
  final Topping topping;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _ToppingItem({
    required this.topping,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Topping info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topping.name ?? 'N/A',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                if (topping.description != null)
                  Text(
                    topping.description!,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                Text(
                  '+${topping.price?.toStringAsFixed(0) ?? '0'}đ',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Quantity controls
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove_circle_outline),
                onPressed: quantity > 0 ? onDecrement : null,
              ),
              Container(
                width: 40,
                alignment: Alignment.center,
                child: Text(
                  quantity.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: Icon(Icons.add_circle_outline),
                onPressed: onIncrement,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/colors.dart';
import '../models/restaurant.dart';
import '../providers/menu_item_provider.dart';
import '../providers/restaurant_provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/food_card.dart';
import '../widgets/notification_bell.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadHomeData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadHomeData() async {
    await Future.wait([
      ref.read(restaurantProvider.notifier).loadRestaurants(),
      ref.read(menuItemProvider.notifier).loadMenuItems(),
    ]);
  }

  Future<void> _search(String keyword) async {
    final query = keyword.trim();
    if (query.isEmpty) {
      await ref.read(menuItemProvider.notifier).loadMenuItems();
      return;
    }
    await ref.read(menuItemProvider.notifier).searchMenuItems(query);
  }

  Future<void> _filterByRestaurant(int? restaurantId) async {
    await ref.read(menuItemProvider.notifier).filterByRestaurant(restaurantId);
  }

  @override
  Widget build(BuildContext context) {
    final restaurantState = ref.watch(restaurantProvider);
    final menuState = ref.watch(menuItemProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AppDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: const [NotificationBell(count: 3)],
      ),
      body: RefreshIndicator(
        onRefresh: _loadHomeData,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildSearchBar()),
            SliverToBoxAdapter(
              child: _buildRestaurantSection(
                restaurantState.restaurants,
                menuState.selectedRestaurantId,
              ),
            ),
            SliverToBoxAdapter(child: _buildSectionTitle('Mon dang pho bien')),
            if (menuState.isLoading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (menuState.error != null)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: Text('Loi: ${menuState.error}')),
              )
            else if (menuState.menuItems.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: Text('Khong co mon nao')),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.75,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return FoodCard(menuItem: menuState.menuItems[index]);
                  }, childCount: menuState.menuItems.length),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withAlpha(220)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Food Ordering',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Chon nha hang va mon an tu API backend',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _searchController,
        textInputAction: TextInputAction.search,
        onSubmitted: _search,
        decoration: InputDecoration(
          hintText: 'Tim mon an...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              _searchController.clear();
              _search('');
            },
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildRestaurantSection(
    List<Restaurant> restaurants,
    int? selectedRestaurantId,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Nha hang dang mo'),
        SizedBox(
          height: 132,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _RestaurantChip(
                  label: 'Tat ca',
                  selected: selectedRestaurantId == null,
                  onTap: () => _filterByRestaurant(null),
                );
              }

              final restaurant = restaurants[index - 1];
              return _RestaurantChip(
                label: restaurant.name ?? 'Nha hang',
                selected: selectedRestaurantId == restaurant.id,
                onTap: () => _filterByRestaurant(restaurant.id),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemCount: restaurants.length + 1,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _RestaurantChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _RestaurantChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

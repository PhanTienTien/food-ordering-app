import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/colors.dart';
import '../../providers/admin_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/role_utils.dart';
import '../../widgets/admin_drawer.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminDashboardProvider.notifier).loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminDashboardProvider);
    final summary = state.summary;
    final role = normalizeRole(ref.watch(authProvider).role);
    final isAdmin = role == 'ADMIN';

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: const AdminDrawer(currentRoute: '/admin'),
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(adminDashboardProvider.notifier).loadDashboard();
            },
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
          ? Center(child: Text('Loi: ${state.error}'))
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(summary),
                  const SizedBox(height: 12),
                  _buildSummaryCards(summary, isAdmin: isAdmin),
                  const SizedBox(height: 12),
                  _buildTodayRow(summary),
                  const SizedBox(height: 16),
                  _buildQuickActions(isAdmin: isAdmin),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader(Map<String, dynamic>? summary) {
    final restaurantCount = summary?['totalRestaurants']?.toString() ?? '0';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.textDark, Color(0xFF3A3A3A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(24),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.admin_panel_settings,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tong quan he thong',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$restaurantCount nha hang dang duoc quan ly',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(
    Map<String, dynamic>? summary, {
    required bool isAdmin,
  }) {
    final cards = [
      (
        title: 'Don hang',
        value: summary?['totalOrders']?.toString() ?? '0',
        icon: Icons.receipt_long,
        color: Colors.blue,
      ),
      if (isAdmin)
        (
          title: 'Nguoi dung',
          value: summary?['totalUsers']?.toString() ?? '0',
          icon: Icons.people_alt_outlined,
          color: AppColors.success,
        ),
      (
        title: 'Nha hang',
        value: summary?['totalRestaurants']?.toString() ?? '0',
        icon: Icons.storefront_outlined,
        color: AppColors.primary,
      ),
      (
        title: 'Doanh thu',
        value: '${summary?['todayRevenue']?.toStringAsFixed(0) ?? "0"} d',
        icon: Icons.payments_outlined,
        color: Colors.deepPurple,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: cards.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.8,
      ),
      itemBuilder: (context, index) {
        final card = cards[index];
        return _SummaryCard(
          title: card.title,
          value: card.value,
          icon: card.icon,
          color: card.color,
        );
      },
    );
  }

  Widget _buildTodayRow(Map<String, dynamic>? summary) {
    return Row(
      children: [
        Expanded(
          child: _TodayStatCard(
            label: 'Hom nay',
            value: summary?['todayOrders']?.toString() ?? '0',
            caption: 'Don moi',
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _TodayStatCard(
            label: 'Doanh thu',
            value: '${summary?['todayRevenue']?.toStringAsFixed(0) ?? "0"} d',
            caption: 'Trong ngay',
            color: AppColors.success,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions({required bool isAdmin}) {
    final actions = [
      if (isAdmin)
        (
          title: 'Users',
          subtitle: 'Tai khoan',
          icon: Icons.people_outline,
          color: Colors.blue,
          route: '/admin/users',
        ),
      (
        title: 'Restaurants',
        subtitle: 'Quan an',
        icon: Icons.storefront_outlined,
        color: AppColors.primary,
        route: '/admin/restaurants',
      ),
      (
        title: 'Categories',
        subtitle: 'Danh muc',
        icon: Icons.category_outlined,
        color: AppColors.success,
        route: '/admin/categories',
      ),
      (
        title: 'Reports',
        subtitle: 'Bao cao',
        icon: Icons.bar_chart_outlined,
        color: Colors.deepPurple,
        route: '/admin/reports',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quan ly nhanh',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 10),
        ...actions.map(
          (action) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _ActionTile(
              title: action.title,
              subtitle: action.subtitle,
              icon: action.icon,
              color: action.color,
              onTap: () => Navigator.pushNamed(context, action.route),
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withAlpha(22),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TodayStatCard extends StatelessWidget {
  final String label;
  final String value;
  final String caption;
  final Color color;

  const _TodayStatCard({
    required this.label,
    required this.value,
    required this.caption,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            caption,
            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.divider),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withAlpha(22),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

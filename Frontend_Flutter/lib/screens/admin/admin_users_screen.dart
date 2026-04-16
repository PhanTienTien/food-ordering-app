import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/colors.dart';
import '../../models/user.dart';
import '../../providers/admin_provider.dart';

class AdminUsersScreen extends ConsumerStatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  ConsumerState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends ConsumerState<AdminUsersScreen> {
  String _selectedRole = 'ALL';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminUsersProvider.notifier).loadUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminUsersProvider);

    final filteredUsers = _selectedRole == 'ALL'
        ? state.users
        : state.users.where((u) => u.role == _selectedRole).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Quản lý Users',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () {
              ref.read(adminUsersProvider.notifier).loadUsers();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Role Filter
          _buildRoleFilter(),

          // Users List
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.error != null
                    ? Center(child: Text('Lỗi: ${state.error}'))
                    : filteredUsers.isEmpty
                        ? const Center(child: Text('Không có users'))
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: filteredUsers.length,
                            itemBuilder: (context, index) {
                              return _UserCard(
                                user: filteredUsers[index],
                                onLock: () => _lockUser(filteredUsers[index].id!),
                                onUnlock: () => _unlockUser(filteredUsers[index].id!),
                                onDelete: () => _showDeleteDialog(filteredUsers[index]),
                              );
                            },
                          ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to create user screen
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildRoleFilter() {
    final roles = [
      {'code': 'ALL', 'label': 'Tất cả'},
      {'code': 'ADMIN', 'label': 'Admin'},
      {'code': 'STAFF', 'label': 'Staff'},
      {'code': 'CUSTOMER', 'label': 'Customer'},
    ];

    return Container(
      height: 50,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: roles.length,
        itemBuilder: (context, index) {
          final role = roles[index];
          final isSelected = _selectedRole == role['code'];

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(role['label']!),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() {
                    _selectedRole = role['code']!;
                  });
                }
              },
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _lockUser(int userId) async {
    final success = await ref.read(adminUsersProvider.notifier).lockUser(userId);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã khóa tài khoản')),
      );
    }
  }

  Future<void> _unlockUser(int userId) async {
    final success = await ref.read(adminUsersProvider.notifier).unlockUser(userId);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã mở khóa tài khoản')),
      );
    }
  }

  void _showDeleteDialog(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa user'),
        content: Text('Bạn có chắc muốn xóa ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await ref.read(adminUsersProvider.notifier).deleteUser(user.id!);
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Đã xóa user')),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final User user;
  final VoidCallback onLock;
  final VoidCallback onUnlock;
  final VoidCallback onDelete;

  const _UserCard({
    required this.user,
    required this.onLock,
    required this.onUnlock,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isLocked = user.status == 'SUSPENDED';
    final roleColor = _getRoleColor(user.role ?? 'CUSTOMER');

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: roleColor.withOpacity(0.1),
          child: Icon(
            _getRoleIcon(user.role ?? 'CUSTOMER'),
            color: roleColor,
          ),
        ),
        title: Text(
          user.name ?? 'Không tên',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: isLocked ? TextDecoration.lineThrough : null,
            color: isLocked ? Colors.grey : Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.email ?? ''),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: roleColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    user.role ?? 'CUSTOMER',
                    style: TextStyle(
                      color: roleColor,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: isLocked ? Colors.red[100] : Colors.green[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isLocked ? 'Đã khóa' : 'Hoạt động',
                    style: TextStyle(
                      color: isLocked ? Colors.red[700] : Colors.green[700],
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'lock':
                onLock();
                break;
              case 'unlock':
                onUnlock();
                break;
              case 'delete':
                onDelete();
                break;
            }
          },
          itemBuilder: (context) => [
            if (!isLocked)
              const PopupMenuItem(
                value: 'lock',
                child: Row(
                  children: [
                    Icon(Icons.lock, color: Colors.orange),
                    SizedBox(width: 8),
                    Text('Khóa'),
                  ],
                ),
              ),
            if (isLocked)
              const PopupMenuItem(
                value: 'unlock',
                child: Row(
                  children: [
                    Icon(Icons.lock_open, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Mở khóa'),
                  ],
                ),
              ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Xóa'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'ADMIN':
        return Colors.purple;
      case 'STAFF':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  IconData _getRoleIcon(String role) {
    switch (role) {
      case 'ADMIN':
        return Icons.admin_panel_settings;
      case 'STAFF':
        return Icons.badge;
      default:
        return Icons.person;
    }
  }
}

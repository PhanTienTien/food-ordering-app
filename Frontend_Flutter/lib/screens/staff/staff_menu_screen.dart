// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants/colors.dart';
import '../../models/menu_item.dart';
import '../../providers/staff_provider.dart';
import '../../services/file_service.dart';
import '../../utils/image_utils.dart';

class StaffMenuScreen extends ConsumerStatefulWidget {
  final int restaurantId;

  const StaffMenuScreen({super.key, required this.restaurantId});

  @override
  ConsumerState<StaffMenuScreen> createState() => _StaffMenuScreenState();
}

class _StaffMenuScreenState extends ConsumerState<StaffMenuScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(staffMenuProvider.notifier).setRestaurantId(widget.restaurantId);
      ref.read(staffMenuProvider.notifier).loadMenuItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(staffMenuProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Quản lý thực đơn',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () {
              ref.read(staffMenuProvider.notifier).loadMenuItems();
            },
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black),
            onPressed: () {
              _showAddMenuItemDialog();
            },
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
          ? Center(child: Text('Lỗi: ${state.error}'))
          : state.menuItems.isEmpty
          ? const Center(child: Text('Chưa có món nào'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.menuItems.length,
              itemBuilder: (context, index) {
                return _MenuItemCard(
                  item: state.menuItems[index],
                  onToggleStatus: () => _toggleStatus(state.menuItems[index]),
                  onEdit: () => _showEditDialog(state.menuItems[index]),
                );
              },
            ),
    );
  }

  Future<void> _toggleStatus(MenuItem item) async {
    final newStatus = item.status == 'AVAILABLE' ? 'OUT_OF_STOCK' : 'AVAILABLE';
    final success = await ref
        .read(staffMenuProvider.notifier)
        .toggleItemStatus(item.id!, newStatus);
    if (!context.mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            newStatus == 'AVAILABLE'
                ? '${item.name} đã bật bán'
                : '${item.name} đã tắt bán',
          ),
        ),
      );
    }
  }

  void _showEditDialog(MenuItem item) {
    final priceController = TextEditingController(
      text: item.price.toStringAsFixed(0),
    );
    final discountController = TextEditingController(
      text: item.discountPrice?.toStringAsFixed(0) ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sửa: ${item.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Giá gốc',
                suffixText: 'đ',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: discountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Giá khuyến mãi',
                suffixText: 'đ',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _updatePrice(
                item,
                priceController.text.trim(),
                discountController.text.trim(),
              );
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void _showAddMenuItemDialog() {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final discountController = TextEditingController();
    final imageController = TextEditingController();
    final descriptionController = TextEditingController();
    final categoryIdController = TextEditingController();
    String? uploadedImageUrl;
    bool isUploading = false;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Thêm món mới'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Tên món'),
                    validator: (v) => v == null || v.isEmpty ? 'Bắt buộc' : null,
                  ),
                  TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: 'Giá gốc'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v == null || double.tryParse(v) == null
                        ? 'Phải là số'
                        : null,
                  ),
                  TextFormField(
                    controller: discountController,
                    decoration: const InputDecoration(
                      labelText: 'Giá khuyến mãi',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: imageController,
                          decoration: const InputDecoration(labelText: 'Ảnh URL'),
                          readOnly: uploadedImageUrl != null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.photo_library),
                        onPressed: isUploading
                            ? null
                            : () async {
                                final picker = ImagePicker();
                                final pickedFile = await picker.pickImage(
                                  source: ImageSource.gallery,
                                  imageQuality: 80,
                                );
                                if (pickedFile != null && dialogContext.mounted) {
                                  setDialogState(() => isUploading = true);
                                  try {
                                    final fileService = FileService();
                                    final url = await fileService.uploadImage(pickedFile.path);
                                    if (url != null && dialogContext.mounted) {
                                      setDialogState(() {
                                        uploadedImageUrl = url;
                                        imageController.text = url;
                                      });
                                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                                        const SnackBar(content: Text('Đã upload ảnh thành công')),
                                      );
                                    }
                                  } catch (e) {
                                    if (dialogContext.mounted) {
                                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                                        SnackBar(content: Text('Upload thất bại: $e')),
                                      );
                                    }
                                  } finally {
                                    if (dialogContext.mounted) {
                                      setDialogState(() => isUploading = false);
                                    }
                                  }
                                }
                              },
                        tooltip: 'Chọn ảnh từ thiết bị',
                      ),
                      if (isUploading)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                    ],
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Mô tả'),
                  ),
                  TextFormField(
                    controller: categoryIdController,
                    decoration: const InputDecoration(labelText: 'Category ID'),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: isUploading
                  ? null
                  : () async {
                      if (!(formKey.currentState?.validate() ?? false)) return;
                      Navigator.pop(dialogContext);
                      final payload = <String, dynamic>{
                        'name': nameController.text.trim(),
                        'price': double.parse(priceController.text.trim()),
                        'discountPrice': discountController.text.trim().isEmpty
                            ? null
                            : double.tryParse(discountController.text.trim()),
                        'image': imageController.text.trim().isEmpty
                            ? null
                            : imageController.text.trim(),
                        'description': descriptionController.text.trim().isEmpty
                            ? null
                            : descriptionController.text.trim(),
                        'restaurantId': widget.restaurantId,
                        'categoryId': categoryIdController.text.trim().isEmpty
                            ? null
                            : int.tryParse(categoryIdController.text.trim()),
                      };
                      final success = await ref
                          .read(staffMenuProvider.notifier)
                          .createMenuItem(payload);
                      if (!context.mounted) return;
                      if (success) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text('Đã thêm món')));
                      }
                    },
              child: const Text('Lưu'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updatePrice(
    MenuItem item,
    String priceText,
    String discountText,
  ) async {
    final price = double.tryParse(priceText);
    final discount = discountText.isEmpty ? 0.0 : double.tryParse(discountText);
    if (price == null || discount == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Giá không hợp lệ')));
      return;
    }

    final success = await ref
        .read(staffMenuProvider.notifier)
        .updateItemPrice(item.id!, price, discount);
    if (!context.mounted) return;
    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã cập nhật giá')));
    }
  }
}

class _MenuItemCard extends StatelessWidget {
  final MenuItem item;
  final VoidCallback onToggleStatus;
  final VoidCallback onEdit;

  const _MenuItemCard({
    required this.item,
    required this.onToggleStatus,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isAvailable = item.status == 'AVAILABLE';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            ImageUtils.buildImageUrl(item.image).isNotEmpty
                ? ImageUtils.buildImageUrl(item.image)
                : 'https://via.placeholder.com/60',
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 60,
              height: 60,
              color: Colors.grey[300],
              child: const Icon(Icons.image_not_supported),
            ),
          ),
        ),
        title: Text(
          item.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: isAvailable ? null : TextDecoration.lineThrough,
            color: isAvailable ? Colors.black : Colors.grey,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            if (item.discountPrice != null && item.discountPrice! > 0) ...[
              Text(
                '${item.price.toStringAsFixed(0)} đ',
                style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              Text(
                '${item.discountPrice?.toStringAsFixed(0) ?? "0"} đ',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ] else
              Text(
                '${item.price.toStringAsFixed(0)} đ',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isAvailable ? Colors.green[100] : Colors.red[100],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                isAvailable ? 'Còn hàng' : 'Hết hàng',
                style: TextStyle(
                  color: isAvailable ? Colors.green[700] : Colors.red[700],
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: onEdit,
            ),
            Switch(
              value: isAvailable,
              onChanged: (_) => onToggleStatus(),
              activeThumbColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}

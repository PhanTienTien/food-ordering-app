// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/colors.dart';
import '../models/address.dart';
import '../services/address_service.dart';

class AddressScreen extends ConsumerStatefulWidget {
  final int userId;

  const AddressScreen({required this.userId, super.key});

  @override
  ConsumerState<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends ConsumerState<AddressScreen> {
  final AddressService _addressService = AddressService();
  List<Address> addresses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    try {
      final loaded = await _addressService.getAddressesByUser(widget.userId);
      setState(() {
        addresses = loaded;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Địa chỉ của tôi'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddAddressDialog(),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : addresses.isEmpty
          ? Center(child: Text('Chưa có địa chỉ nào'))
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                return _AddressCard(
                  address: addresses[index],
                  onSetDefault: () => _setDefaultAddress(addresses[index].id!),
                  onEdit: () => _showEditAddressDialog(addresses[index]),
                  onDelete: () => _deleteAddress(addresses[index].id!),
                );
              },
            ),
    );
  }

  Future<void> _setDefaultAddress(int id) async {
    try {
      await _addressService.setDefaultAddress(id, widget.userId);
      await _loadAddresses();
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Đã đặt làm địa chỉ mặc định')));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    }
  }

  Future<void> _deleteAddress(int id) async {
    try {
      await _addressService.deleteAddress(id);
      await _loadAddresses();
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Đã xóa địa chỉ')));
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    }
  }

  void _showAddAddressDialog() {
    final formKey = GlobalKey<FormState>();
    final fullNameController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();
    final cityController = TextEditingController();
    final districtController = TextEditingController();
    final wardController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Thêm địa chỉ mới'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: fullNameController,
                  decoration: InputDecoration(labelText: 'Họ tên'),
                  validator: (v) => v?.isEmpty ?? true ? 'Bắt buộc' : null,
                ),
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: 'Số điện thoại'),
                  validator: (v) => v?.isEmpty ?? true ? 'Bắt buộc' : null,
                ),
                TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: 'Địa chỉ'),
                  validator: (v) => v?.isEmpty ?? true ? 'Bắt buộc' : null,
                ),
                TextFormField(
                  controller: cityController,
                  decoration: InputDecoration(labelText: 'Thành phố'),
                ),
                TextFormField(
                  controller: districtController,
                  decoration: InputDecoration(labelText: 'Quận/Huyện'),
                ),
                TextFormField(
                  controller: wardController,
                  decoration: InputDecoration(labelText: 'Phường/Xã'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                try {
                  await _addressService.createAddress(
                    userId: widget.userId,
                    fullName: fullNameController.text,
                    phoneNumber: phoneController.text,
                    addressLine: addressController.text,
                    city: cityController.text,
                    district: districtController.text,
                    ward: wardController.text,
                  );
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  await _loadAddresses();
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
                }
              }
            },
            child: Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void _showEditAddressDialog(Address address) {
    final formKey = GlobalKey<FormState>();
    final fullNameController = TextEditingController(text: address.fullName);
    final phoneController = TextEditingController(text: address.phoneNumber);
    final addressController = TextEditingController(text: address.addressLine);
    final cityController = TextEditingController(text: address.city);
    final districtController = TextEditingController(text: address.district);
    final wardController = TextEditingController(text: address.ward);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sửa địa chỉ'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: fullNameController,
                  decoration: InputDecoration(labelText: 'Họ tên'),
                  validator: (v) => v?.isEmpty ?? true ? 'Bắt buộc' : null,
                ),
                TextFormField(
                  controller: phoneController,
                  decoration: InputDecoration(labelText: 'Số điện thoại'),
                  validator: (v) => v?.isEmpty ?? true ? 'Bắt buộc' : null,
                ),
                TextFormField(
                  controller: addressController,
                  decoration: InputDecoration(labelText: 'Địa chỉ'),
                  validator: (v) => v?.isEmpty ?? true ? 'Bắt buộc' : null,
                ),
                TextFormField(
                  controller: cityController,
                  decoration: InputDecoration(labelText: 'Thành phố'),
                ),
                TextFormField(
                  controller: districtController,
                  decoration: InputDecoration(labelText: 'Quận/Huyện'),
                ),
                TextFormField(
                  controller: wardController,
                  decoration: InputDecoration(labelText: 'Phường/Xã'),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                try {
                  await _addressService.updateAddress(
                    address.id!,
                    fullName: fullNameController.text,
                    phoneNumber: phoneController.text,
                    addressLine: addressController.text,
                    city: cityController.text,
                    district: districtController.text,
                    ward: wardController.text,
                  );
                  if (!context.mounted) return;
                  Navigator.pop(context);
                  await _loadAddresses();
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
                }
              }
            },
            child: Text('Lưu'),
          ),
        ],
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final Address address;
  final VoidCallback onSetDefault;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AddressCard({
    required this.address,
    required this.onSetDefault,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  address.fullName ?? '',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                if (address.isDefault ?? false)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Mặc định',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8),
            Text(address.phoneNumber ?? ''),
            SizedBox(height: 4),
            Text(address.addressLine ?? ''),
            if (address.ward != null) Text(address.ward!),
            if (address.district != null) Text(address.district!),
            if (address.city != null) Text(address.city!),
            SizedBox(height: 12),
            Row(
              children: [
                TextButton.icon(
                  onPressed: onSetDefault,
                  icon: Icon(Icons.star_outline, size: 16),
                  label: Text('Đặt mặc định'),
                ),
                Spacer(),
                IconButton(icon: Icon(Icons.edit, size: 20), onPressed: onEdit),
                IconButton(
                  icon: Icon(Icons.delete, size: 20),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

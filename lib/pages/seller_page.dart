import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/product_provider.dart';
import '../pages/models/produk_model.dart';
import '../widgets/bottom_navigation_bar.dart';

class SellerPage extends StatefulWidget {
  const SellerPage({super.key});

  @override
  State<SellerPage> createState() => _SellerState();
}

class _SellerState extends State<SellerPage> {
  String selectedCategory = 'Elektronik';
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  final List<XFile?> _images = List<XFile?>.filled(4, null, growable: false);

  bool _isLoading = false;

  final List<String> categories = [
    'Elektronik',
    'Fashion',
    'Makanan',
    'Kendaraan',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Foto'),
            Row(children: List.generate(4, (i) => _buildPhotoBox(i))),
            const SizedBox(height: 24),
            _sectionTitle('Kategori'),
            _buildCategoryDropdown(),
            const SizedBox(height: 24),
            _sectionTitle('Nama Produk'),
            _buildTextField(
              controller: nameController,
              hintText: 'Tambahkan nama produk',
            ),
            const SizedBox(height: 24),
            _sectionTitle('Harga'),
            _buildTextField(
              controller: priceController,
              hintText: 'Tambahkan harga',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            _sectionTitle('Alamat'),
            _buildTextField(
              controller: addressController,
              hintText: 'Tambahkan alamat',
            ),
            const SizedBox(height: 24),
            _sectionTitle('Deskripsi'),
            _buildTextField(
              controller: descriptionController,
              hintText: 'Tambahkan deskripsi',
              maxLines: 5,
            ),
            const SizedBox(height: 40),
            _buildNextButton(),
            const SizedBox(height: 100), // Add space for bottom nav
          ],
        ),
      ),
      bottomNavigationBar: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final userRole = authProvider.userModel?.role ?? 'buyer';
          return CustomBottomNavigationBar(
            currentIndex: 2, // Seller tab selected
            userRole: userRole,
          );
        },
      ),
    );
  }

  AppBar _buildAppBar() => AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    automaticallyImplyLeading: false,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Seller',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            shape: BoxShape.circle,
          ),
          child: IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(Icons.close, size: 18, color: Colors.black),
            onPressed: () {
              // Konfirmasi sebelum keluar jika ada data yang diisi
              if (_hasUnsavedData()) {
                _showExitConfirmation();
              } else {
                context.go('/menu');
              }
            },
          ),
        ),
      ],
    ),
  );

  Widget _buildPhotoBox(int index) {
    final img = _images[index];
    return Expanded(
      child: GestureDetector(
        onTap: () => _pickImage(index),
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (img != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child:
                        kIsWeb
                            ? Image.network(img.path, fit: BoxFit.cover)
                            : Image.file(File(img.path), fit: BoxFit.cover),
                  ),
                if (img == null)
                  Icon(
                    Icons.add_circle_outline,
                    color: Colors.grey[400],
                    size: 28,
                  ),
                if (img != null)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => setState(() => _images[index] = null),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(4),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(int index) async {
    final XFile? picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked != null) {
      setState(() => _images[index] = picked);
    }
  }

  Widget _sectionTitle(String t) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        t,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      const SizedBox(height: 16),
    ],
  );

  Widget _buildCategoryDropdown() => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.black),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: selectedCategory,
        isExpanded: true,
        items:
            categories
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
        onChanged: (v) => setState(() => selectedCategory = v!),
      ),
    ),
  );

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.brown[300]!, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: maxLines > 1 ? 16 : 14,
        ),
      ),
    ),
  );

  Widget _buildNextButton() => SizedBox(
    width: double.infinity,
    height: 56,
    child: ElevatedButton(
      onPressed: _isLoading ? null : _handleNextButton,
      style: ElevatedButton.styleFrom(
        backgroundColor: _isLoading ? Colors.grey : Colors.brown[300],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 0,
      ),
      child:
          _isLoading
              ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
              : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Simpan Produk',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.save, color: Colors.white, size: 18),
                ],
              ),
    ),
  );

  Future<void> _handleNextButton() async {
    // Validasi input
    if (_images.every((img) => img == null)) {
      return _showSnack('Minimal satu foto produk harus dipilih');
    }
    if (nameController.text.isEmpty) {
      return _showSnack('Nama produk harus diisi');
    }
    if (priceController.text.isEmpty) {
      return _showSnack('Harga harus diisi');
    }
    if (addressController.text.isEmpty) {
      return _showSnack('Alamat harus diisi');
    }

    // Validasi harga
    final double? price = double.tryParse(
      priceController.text.replaceAll(',', ''),
    );
    if (price == null || price <= 0) {
      return _showSnack('Harga harus berupa angka yang valid');
    }

    setState(() {
      _isLoading = true;
    });

    // Show upload status
    _showSnack('Mengupload gambar ke Firebase Storage...');

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final productProvider = Provider.of<ProductProvider>(
        context,
        listen: false,
      );

      // Pastikan user sudah login
      if (authProvider.userModel == null) {
        if (mounted) {
          _showSnack('Silakan login terlebih dahulu');
          context.go('/login');
        }
        return;
      }

      final user = authProvider.userModel!;

      // Siapkan data produk - DON'T include image paths yet
      final selectedImages =
          _images.where((img) => img != null).cast<XFile>().toList();

      print('Creating product with:');
      print('Name: ${nameController.text}');
      print('Price: $price');
      print('Category: $selectedCategory');
      print('Address: ${addressController.text}');
      print('Description: ${descriptionController.text}');
      print('Images: ${selectedImages.length}');
      print('Seller: ${user.name} (${user.id})');

      // Buat objek produk tanpa images (akan diupload terpisah)
      final newProduct = Produk(
        id: '', // akan di-generate oleh Firebase
        name: nameController.text.trim(),
        deskripsi:
            descriptionController.text.trim().isNotEmpty
                ? descriptionController.text.trim()
                : 'Tidak ada deskripsi',
        harga: price.toInt(), // Convert to int
        category: selectedCategory.toLowerCase(),
        condition: 'Bekas', // default condition
        sellerId: user.id,
        sellerName: user.name,
        toko: user.name, // atau bisa pakai nama toko khusus
        address: addressController.text.trim(),
        images: [], // Empty list - images will be uploaded separately
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        status: 'available',
      );

      // Simpan ke Firebase dengan upload gambar melalui ProductProvider
      final success = await productProvider.addProductWithImages(
        newProduct,
        selectedImages,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (success) {
          _showSnack(
            'Produk berhasil disimpan dengan gambar di Firebase Storage!',
          );

          // Clear form
          nameController.clear();
          priceController.clear();
          addressController.clear();
          descriptionController.clear();
          setState(() {
            selectedCategory = 'Elektronik';
            for (int i = 0; i < _images.length; i++) {
              _images[i] = null;
            }
          });

          // Navigate ke menu setelah delay
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (mounted) {
              context.go('/menu');
            }
          });
        } else {
          _showSnack('Gagal menyimpan produk: ${productProvider.errorMessage}');
        }
      }
    } catch (e) {
      print('Error saving product: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showSnack('Terjadi kesalahan: $e');
      }
    }
  }

  bool _hasUnsavedData() {
    return nameController.text.isNotEmpty ||
        priceController.text.isNotEmpty ||
        addressController.text.isNotEmpty ||
        descriptionController.text.isNotEmpty ||
        _images.any((img) => img != null);
  }

  void _showExitConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text(
            'Ada data yang belum disimpan. Apakah Anda yakin ingin keluar?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/menu');
              },
              child: const Text('Keluar'),
            ),
          ],
        );
      },
    );
  }

  void _showSnack(String msg) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
      backgroundColor: msg.contains('berhasil') ? Colors.green : Colors.red,
    ),
  );

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    addressController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}

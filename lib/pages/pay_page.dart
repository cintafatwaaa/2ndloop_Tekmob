import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '../providers/auth_provider.dart';
import '../providers/transaction_provider.dart';
import '../models/payment_model.dart';
import '../models/transaction_model.dart';
import '../pages/models/produk_model.dart';

class PayPage extends StatefulWidget {
  final Map<String, dynamic>? paymentData;

  const PayPage({super.key, this.paymentData});

  @override
  State<PayPage> createState() => _PayPageState();
}

class _PayPageState extends State<PayPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedPaymentProof;
  bool _isUploadingProof = false;

  Future<void> _pickPaymentProof() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedPaymentProof = image;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memilih gambar: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<String?> _uploadPaymentProof(XFile imageFile) async {
    try {
      setState(() {
        _isUploadingProof = true;
      });

      final fileName =
          'payment_proof_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = FirebaseStorage.instance.ref().child(
        'payment_proofs/$fileName',
      );

      if (kIsWeb) {
        // For web, read bytes from XFile
        final bytes = await imageFile.readAsBytes();
        final uploadTask = ref.putData(bytes);
        final snapshot = await uploadTask.whenComplete(() => null);
        return await snapshot.ref.getDownloadURL();
      } else {
        // For mobile, use file path
        final file = File(imageFile.path);
        final uploadTask = ref.putFile(file);
        final snapshot = await uploadTask.whenComplete(() => null);
        return await snapshot.ref.getDownloadURL();
      }
    } catch (e) {
      print('Error uploading payment proof: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengunggah bukti pembayaran: $e'),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    } finally {
      setState(() {
        _isUploadingProof = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Extract payment data if available
    PaymentData? payment;
    if (widget.paymentData != null) {
      final product = widget.paymentData!['product'] as Produk;
      final quantity = widget.paymentData!['quantity'] as int? ?? 1;
      final buyerId = widget.paymentData!['buyerId'] as String? ?? '';
      final buyerName = widget.paymentData!['buyerName'] as String? ?? '';

      // Get user address from AuthProvider
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userAddress =
          authProvider.userModel?.address ?? 'Alamat belum diatur';

      payment = PaymentData(
        product: product,
        quantity: quantity,
        buyerId: buyerId,
        buyerName: buyerName,
        deliveryAddress: userAddress,
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/menu');
            }
          },
        ),
        title: const Text(
          'Pembayaran',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _productCard(payment),
            const SizedBox(height: 16),
            _detailCard(payment),
            const SizedBox(height: 16),
            _totalCard(payment),
            const SizedBox(height: 16),
            _bankList(),
            const SizedBox(height: 16),
            const Text(
              'Kirim bukti pembayaran',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            _paymentProofUpload(),
            const SizedBox(height: 24),
            _verifyButton(context, payment),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  BoxDecoration get _boxDecoration => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: const [
      BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
    ],
  );

  Widget _productCard(PaymentData? payment) => Container(
    decoration: _boxDecoration,
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          payment?.product.toko ?? 'Toko Kelontong',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
                image:
                    payment?.product.images.isNotEmpty == true
                        ? DecorationImage(
                          image: NetworkImage(payment!.product.images.first),
                          fit: BoxFit.cover,
                        )
                        : const DecorationImage(
                          image: AssetImage('assets/images/kaos-putih.png'),
                          fit: BoxFit.cover,
                        ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    payment?.product.name ?? 'Kaos Putih',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rp ${payment?.product.harga.toString() ?? '100.000'}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  if (payment != null && payment.quantity > 1) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Qty: ${payment.quantity}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _detailCard(PaymentData? payment) => Container(
    decoration: _boxDecoration,
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rincian Pembayaran',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        if (payment != null) ...[
          _detailRow(
            'Harga Produk (${payment.quantity}x)',
            'Rp ${payment.productTotal.toStringAsFixed(0)}',
          ),
          const SizedBox(height: 8),
        ],
        _detailRow(
          'Biaya Layanan Admin',
          'Rp ${payment?.adminFee.toStringAsFixed(0) ?? '5.000'}',
        ),
        const SizedBox(height: 8),
        _detailRow(
          'Biaya Penayangan 30 Hari',
          'Rp ${payment?.displayFee.toStringAsFixed(0) ?? '40.000'}',
        ),
        const SizedBox(height: 8),
        _detailRow(
          'Pajak Platform (PPN 11%)',
          'Rp ${payment?.tax.toStringAsFixed(0) ?? '11.000'}',
        ),
        const SizedBox(height: 12),
        const Divider(),
        const SizedBox(height: 8),
        const Text(
          'Alamat Pengiriman',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 4),
        Text(
          payment?.deliveryAddress ?? 'Alamat belum diatur',
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ],
    ),
  );

  Widget _detailRow(String label, String value) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: const TextStyle(fontSize: 14, color: Colors.black87)),
      Text(value, style: const TextStyle(fontSize: 14, color: Colors.black87)),
    ],
  );

  Widget _totalCard(PaymentData? payment) => Container(
    decoration: _boxDecoration,
    padding: const EdgeInsets.all(16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Total Pembayaran',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(
          'Rp ${payment?.grandTotal.toStringAsFixed(0) ?? '156.000'}',
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    ),
  );

  Widget _bankList() => Container(
    decoration: _boxDecoration,
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pembayaran',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        _bankRow(Icons.account_balance, 'Bank BCA', '83172292770'),
        const SizedBox(height: 8),
        _bankRow(Icons.account_balance, 'Bank BRI', '53218290120'),
        const SizedBox(height: 8),
        _bankRow(Icons.account_balance, 'Bank Mandiri', '129012920128999'),
        const SizedBox(height: 8),
        _bankRow(Icons.account_balance, 'Bank BSI', '72188191982'),
      ],
    ),
  );

  Widget _bankRow(IconData icon, String bank, String acc) => Row(
    children: [
      Icon(icon, size: 20, color: Colors.grey[600]),
      const SizedBox(width: 12),
      Expanded(
        child: Text(
          bank,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ),
      Text(
        acc,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );

  Widget _paymentProofUpload() => Container(
    decoration: _boxDecoration,
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload Bukti Pembayaran',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        if (_selectedPaymentProof != null)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Bukti pembayaran dipilih',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selectedPaymentProof = null;
                        });
                      },
                      child: const Text('Hapus'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Preview gambar
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child:
                      kIsWeb
                          ? FutureBuilder<Uint8List>(
                            future: _selectedPaymentProof!.readAsBytes(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return GestureDetector(
                                  onTap: () {
                                    _showImagePreview(context);
                                  },
                                  child: Image.memory(
                                    snapshot.data!,
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                );
                              } else {
                                return Container(
                                  height: 200,
                                  width: double.infinity,
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }
                            },
                          )
                          : GestureDetector(
                            onTap: () {
                              _showImagePreview(context);
                            },
                            child: Image.file(
                              File(_selectedPaymentProof!.path),
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Preview bukti pembayaran (tap untuk melihat ukuran penuh)',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _isUploadingProof ? null : _pickPaymentProof,
            icon:
                _isUploadingProof
                    ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : const Icon(Icons.upload_file),
            label: Text(
              _isUploadingProof
                  ? 'Memilih gambar...'
                  : (_selectedPaymentProof != null
                      ? 'Ganti Bukti Pembayaran'
                      : 'Pilih Bukti Pembayaran'),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.brown[100],
              foregroundColor: Colors.brown[800],
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Silakan upload bukti transfer pembayaran Anda',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    ),
  );

  Widget _verifyButton(BuildContext context, PaymentData? payment) => SizedBox(
    width: double.infinity,
    child: Consumer<TransactionProvider>(
      builder: (context, transactionProvider, child) {
        return ElevatedButton(
          onPressed:
              transactionProvider.isLoading || _isUploadingProof
                  ? null
                  : () async {
                    if (payment != null) {
                      // Upload payment proof if selected
                      String? paymentProofUrl;
                      if (_selectedPaymentProof != null) {
                        paymentProofUrl = await _uploadPaymentProof(
                          _selectedPaymentProof!,
                        );
                        if (paymentProofUrl == null) {
                          // Upload failed, show error and return
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Gagal mengunggah bukti pembayaran',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                      }

                      // Check if this is updating an existing transaction
                      final existingTransactionId =
                          widget.paymentData?['transactionId'] as String?;

                      if (existingTransactionId != null) {
                        // Update existing transaction with payment proof
                        final success = await transactionProvider
                            .updatePaymentStatus(
                              existingTransactionId,
                              paymentProofUrl != null ? 'uploaded' : 'pending',
                              paymentProof: paymentProofUrl,
                            );

                        if (success) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  paymentProofUrl != null
                                      ? 'Bukti pembayaran berhasil diupload!'
                                      : 'Status pembayaran berhasil diupdate!',
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );

                            // Navigate back to orders page
                            Navigator.of(context).pop();
                          }
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Gagal mengupdate transaksi: ${transactionProvider.errorMessage ?? "Unknown error"}',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      } else {
                        // Create new transaction
                        final transaction = TransactionModel(
                          id: '', // Will be set by Firestore
                          buyerId: payment.buyerId,
                          buyerName: payment.buyerName,
                          sellerId: payment.product.sellerId,
                          sellerName: payment.product.sellerName,
                          productId: payment.product.id,
                          productName: payment.product.name,
                          productImages: payment.product.images,
                          productPrice: payment.product.harga.toInt(),
                          quantity: payment.quantity,
                          totalAmount: payment.grandTotal.toInt(),
                          paymentMethod: 'bank_transfer', // Default for now
                          paymentStatus:
                              paymentProofUrl != null ? 'uploaded' : 'pending',
                          orderStatus: 'pending',
                          paymentProof: paymentProofUrl,
                          shippingAddress: payment.deliveryAddress,
                          notes: null,
                          createdAt: DateTime.now(),
                          updatedAt: DateTime.now(),
                        );

                        // Save transaction to database
                        final success = await transactionProvider
                            .createTransaction(transaction);

                        if (success) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  paymentProofUrl != null
                                      ? 'Pesanan berhasil dibuat dengan bukti pembayaran!'
                                      : 'Pesanan berhasil dibuat! Silakan upload bukti pembayaran.',
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );

                            // Navigate to orders page after delay
                            Future.delayed(const Duration(seconds: 2), () {
                              if (context.mounted) {
                                Navigator.of(
                                  context,
                                ).pushReplacementNamed('/pesanan');
                              }
                            });
                          }
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Gagal membuat pesanan: ${transactionProvider.errorMessage ?? "Unknown error"}',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Data pembayaran tidak valid'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown[400],
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
          ),
          child:
              transactionProvider.isLoading || _isUploadingProof
                  ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                  : Text(
                    // Check if this is updating existing transaction
                    widget.paymentData?['transactionId'] != null
                        ? (_selectedPaymentProof != null
                            ? 'Update Bukti Pembayaran'
                            : 'Update Transaksi')
                        : (_selectedPaymentProof != null
                            ? 'Buat Pesanan & Upload Bukti'
                            : 'Buat Pesanan'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
        );
      },
    ),
  );

  // Method to show full-size image preview
  void _showImagePreview(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            backgroundColor: Colors.transparent,
            child: Stack(
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child:
                        kIsWeb
                            ? FutureBuilder<Uint8List>(
                              future: _selectedPaymentProof!.readAsBytes(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Image.memory(
                                    snapshot.data!,
                                    fit: BoxFit.contain,
                                  );
                                } else {
                                  return Container(
                                    width: 300,
                                    height: 300,
                                    color: Colors.grey[300],
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }
                              },
                            )
                            : Image.file(
                              File(_selectedPaymentProof!.path),
                              fit: BoxFit.contain,
                            ),
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 20,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/bottom_navigation_bar.dart';
import '../models/transaction_model.dart';
import 'pay_page.dart';

class PesananPage extends StatefulWidget {
  const PesananPage({super.key});

  @override
  State<PesananPage> createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final transactionProvider = Provider.of<TransactionProvider>(
        context,
        listen: false,
      );

      if (authProvider.userModel != null) {
        transactionProvider.loadTransactionsByBuyer(authProvider.userModel!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFA68E73),
        title: const Text(
          'Pesanan Saya',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, transactionProvider, child) {
          if (transactionProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (transactionProvider.transactions.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Belum ada pesanan',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Yuk belanja produk favorit kamu!',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: transactionProvider.transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactionProvider.transactions[index];
              return _buildTransactionCard(transaction);
            },
          );
        },
      ),
      bottomNavigationBar: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final userRole = authProvider.userModel?.role ?? 'buyer';
          return CustomBottomNavigationBar(currentIndex: 2, userRole: userRole);
        },
      ),
    );
  }

  Widget _buildTransactionCard(TransactionModel transaction) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pesanan #${transaction.id.substring(0, 8)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildStatusChip(
                      transaction.paymentStatus,
                      isPaymentStatus: true,
                    ),
                    const SizedBox(height: 4),
                    _buildStatusChip(
                      transaction.orderStatus,
                      isPaymentStatus: false,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Toko: ${transaction.sellerName}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            // Product details with image
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product image
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[300],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child:
                        transaction.productImages.isNotEmpty
                            ? Image.network(
                              transaction.productImages.first,
                              fit: BoxFit.cover,
                              loadingBuilder: (
                                context,
                                child,
                                loadingProgress,
                              ) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.image,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            )
                            : const Icon(Icons.image, color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 12),
                // Product info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Produk: ${transaction.productName}',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Qty: ${transaction.quantity}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Harga: Rp ${transaction.productPrice.toStringAsFixed(0)}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: Rp ${transaction.totalAmount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFA68E73),
                  ),
                ),
                Text(
                  _formatDate(transaction.createdAt),
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
            // Display payment proof if available
            if (transaction.paymentProof != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'Bukti Pembayaran',
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap:
                          () => _showPaymentProofDialog(
                            context,
                            transaction.paymentProof!,
                          ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.network(
                          transaction.paymentProof!,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              height: 100,
                              width: double.infinity,
                              color: Colors.grey[300],
                              child: const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 100,
                              width: double.infinity,
                              color: Colors.grey[300],
                              child: const Center(
                                child: Icon(Icons.error, color: Colors.red),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Tap untuk melihat ukuran penuh',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            // Action buttons based on payment status
            if (transaction.paymentStatus == 'pending' &&
                transaction.paymentProof == null) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _cancelOrder(transaction);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Batalkan'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _navigateToPayment(transaction);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFA68E73),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Bayar'),
                    ),
                  ),
                ],
              ),
            ] else if (transaction.paymentStatus == 'uploaded') ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.access_time, color: Colors.blue, size: 16),
                    const SizedBox(width: 8),
                    const Text(
                      'Menunggu konfirmasi pembayaran',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ] else if (transaction.paymentStatus == 'paid') ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Pembayaran telah dikonfirmasi',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status, {bool isPaymentStatus = false}) {
    Color backgroundColor;
    Color textColor;
    String label;

    if (isPaymentStatus) {
      // Payment status
      switch (status.toLowerCase()) {
        case 'pending':
          backgroundColor = Colors.orange.shade100;
          textColor = Colors.orange.shade800;
          label = 'Belum Bayar';
          break;
        case 'uploaded':
          backgroundColor = Colors.blue.shade100;
          textColor = Colors.blue.shade800;
          label = 'Menunggu Konfirmasi';
          break;
        case 'paid':
          backgroundColor = Colors.green.shade100;
          textColor = Colors.green.shade800;
          label = 'Lunas';
          break;
        case 'failed':
          backgroundColor = Colors.red.shade100;
          textColor = Colors.red.shade800;
          label = 'Gagal';
          break;
        default:
          backgroundColor = Colors.grey.shade100;
          textColor = Colors.grey.shade800;
          label = status;
      }
    } else {
      // Order status
      switch (status.toLowerCase()) {
        case 'pending':
          backgroundColor = Colors.orange.shade100;
          textColor = Colors.orange.shade800;
          label = 'Menunggu';
          break;
        case 'confirmed':
          backgroundColor = Colors.blue.shade100;
          textColor = Colors.blue.shade800;
          label = 'Dikonfirmasi';
          break;
        case 'shipped':
          backgroundColor = Colors.purple.shade100;
          textColor = Colors.purple.shade800;
          label = 'Dikirim';
          break;
        case 'delivered':
          backgroundColor = Colors.green.shade100;
          textColor = Colors.green.shade800;
          label = 'Diterima';
          break;
        case 'cancelled':
          backgroundColor = Colors.red.shade100;
          textColor = Colors.red.shade800;
          label = 'Dibatalkan';
          break;
        default:
          backgroundColor = Colors.grey.shade100;
          textColor = Colors.grey.shade800;
          label = status;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Show payment proof in full screen dialog
  void _showPaymentProofDialog(BuildContext context, String paymentProofUrl) {
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
                    child: Image.network(
                      paymentProofUrl,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error, color: Colors.red, size: 48),
                                SizedBox(height: 8),
                                Text(
                                  'Gagal memuat gambar',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
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
                Positioned(
                  bottom: 40,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Bukti Pembayaran',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  // Cancel order
  void _cancelOrder(TransactionModel transaction) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Batalkan Pesanan'),
            content: const Text(
              'Apakah Anda yakin ingin membatalkan pesanan ini?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();

                  final transactionProvider = Provider.of<TransactionProvider>(
                    context,
                    listen: false,
                  );

                  await transactionProvider.updateOrderStatus(
                    transaction.id,
                    'cancelled',
                  );

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pesanan berhasil dibatalkan'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                child: const Text('Ya, Batalkan'),
              ),
            ],
          ),
    );
  }

  // Navigate to payment with transaction data
  void _navigateToPayment(TransactionModel transaction) async {
    // Convert transaction back to payment data format
    final paymentData = {
      'product': {
        'id': transaction.productId,
        'name': transaction.productName,
        'images': transaction.productImages,
        'harga': transaction.productPrice,
        'sellerId': transaction.sellerId,
        'sellerName': transaction.sellerName,
        'toko': transaction.sellerName,
        'deskripsi': 'Produk ${transaction.productName}',
        'category': 'general',
        'condition': 'Bekas',
        'address': transaction.shippingAddress ?? '',
        'createdAt': transaction.createdAt.toIso8601String(),
        'updatedAt': transaction.updatedAt.toIso8601String(),
        'status': 'available',
      },
      'quantity': transaction.quantity,
      'buyerId': transaction.buyerId,
      'buyerName': transaction.buyerName,
      'transactionId': transaction.id, // Add transaction ID for update
    };

    // Navigate to payment page with transaction data
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PayPage(paymentData: paymentData),
      ),
    );

    // If payment was successful, refresh the transactions
    if (result == true || result == null) {
      if (mounted) {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        final transactionProvider = Provider.of<TransactionProvider>(
          context,
          listen: false,
        );

        if (authProvider.userModel != null) {
          transactionProvider.loadTransactionsByBuyer(
            authProvider.userModel!.id,
          );
        }
      }
    }
  }
}

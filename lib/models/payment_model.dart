import '../pages/models/produk_model.dart';

class PaymentData {
  final Produk product;
  final int quantity;
  final String buyerId;
  final String buyerName;
  final String deliveryAddress;

  PaymentData({
    required this.product,
    required this.quantity,
    required this.buyerId,
    required this.buyerName,
    required this.deliveryAddress,
  });

  // Calculate total cost
  double get productTotal => (product.harga * quantity).toDouble();
  double get adminFee => 5000.0;
  double get displayFee => 40000.0;
  double get tax => (productTotal + adminFee + displayFee) * 0.11;
  double get grandTotal => productTotal + adminFee + displayFee + tax;

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'buyerId': buyerId,
      'buyerName': buyerName,
      'deliveryAddress': deliveryAddress,
      'productTotal': productTotal,
      'adminFee': adminFee,
      'displayFee': displayFee,
      'tax': tax,
      'grandTotal': grandTotal,
      'createdAt': DateTime.now().toIso8601String(),
    };
  }

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      product: Produk.fromJson(json['product']),
      quantity: json['quantity'] ?? 1,
      buyerId: json['buyerId'] ?? '',
      buyerName: json['buyerName'] ?? '',
      deliveryAddress: json['deliveryAddress'] ?? '',
    );
  }
}

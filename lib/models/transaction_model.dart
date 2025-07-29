import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String id;
  final String buyerId;
  final String buyerName;
  final String sellerId;
  final String sellerName;
  final String productId;
  final String productName;
  final List<String> productImages;
  final int productPrice;
  final int quantity;
  final int totalAmount;
  final String paymentMethod;
  final String paymentStatus; // 'pending', 'paid', 'failed'
  final String
  orderStatus; // 'pending', 'confirmed', 'shipped', 'delivered', 'cancelled'
  final String? paymentProof;
  final String? shippingAddress;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  TransactionModel({
    required this.id,
    required this.buyerId,
    required this.buyerName,
    required this.sellerId,
    required this.sellerName,
    required this.productId,
    required this.productName,
    required this.productImages,
    required this.productPrice,
    required this.quantity,
    required this.totalAmount,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    this.paymentProof,
    this.shippingAddress,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buyerId': buyerId,
      'buyerName': buyerName,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'productId': productId,
      'productName': productName,
      'productImages': productImages,
      'productPrice': productPrice,
      'quantity': quantity,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'orderStatus': orderStatus,
      'paymentProof': paymentProof,
      'shippingAddress': shippingAddress,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create from Firestore document
  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? '',
      buyerId: json['buyerId'] ?? '',
      buyerName: json['buyerName'] ?? '',
      sellerId: json['sellerId'] ?? '',
      sellerName: json['sellerName'] ?? '',
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      productImages: List<String>.from(json['productImages'] ?? []),
      productPrice: json['productPrice'] ?? 0,
      quantity: json['quantity'] ?? 1,
      totalAmount: json['totalAmount'] ?? 0,
      paymentMethod: json['paymentMethod'] ?? '',
      paymentStatus: json['paymentStatus'] ?? 'pending',
      orderStatus: json['orderStatus'] ?? 'pending',
      paymentProof: json['paymentProof'],
      shippingAddress: json['shippingAddress'],
      notes: json['notes'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Create from Firestore DocumentSnapshot
  factory TransactionModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TransactionModel.fromJson(data);
  }

  // Create a copy with updated fields
  TransactionModel copyWith({
    String? id,
    String? buyerId,
    String? buyerName,
    String? sellerId,
    String? sellerName,
    String? productId,
    String? productName,
    List<String>? productImages,
    int? productPrice,
    int? quantity,
    int? totalAmount,
    String? paymentMethod,
    String? paymentStatus,
    String? orderStatus,
    String? paymentProof,
    String? shippingAddress,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      buyerId: buyerId ?? this.buyerId,
      buyerName: buyerName ?? this.buyerName,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImages: productImages ?? this.productImages,
      productPrice: productPrice ?? this.productPrice,
      quantity: quantity ?? this.quantity,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      orderStatus: orderStatus ?? this.orderStatus,
      paymentProof: paymentProof ?? this.paymentProof,
      shippingAddress: shippingAddress ?? this.shippingAddress,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

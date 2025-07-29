import 'package:cloud_firestore/cloud_firestore.dart';

class ShopModel {
  final String id;
  final String ownerId;
  final String ownerName;
  final String shopName;
  final String description;
  final String? logoUrl;
  final String? headerImageUrl;
  final String? address;
  final String? phoneNumber;
  final String? email;
  final List<String> categories;
  final double rating;
  final int totalProducts;
  final int totalSales;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  ShopModel({
    required this.id,
    required this.ownerId,
    required this.ownerName,
    required this.shopName,
    required this.description,
    this.logoUrl,
    this.headerImageUrl,
    this.address,
    this.phoneNumber,
    this.email,
    required this.categories,
    required this.rating,
    required this.totalProducts,
    required this.totalSales,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'shopName': shopName,
      'description': description,
      'logoUrl': logoUrl,
      'headerImageUrl': headerImageUrl,
      'address': address,
      'phoneNumber': phoneNumber,
      'email': email,
      'categories': categories,
      'rating': rating,
      'totalProducts': totalProducts,
      'totalSales': totalSales,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create from Firestore document
  factory ShopModel.fromJson(Map<String, dynamic> json) {
    return ShopModel(
      id: json['id'] ?? '',
      ownerId: json['ownerId'] ?? '',
      ownerName: json['ownerName'] ?? '',
      shopName: json['shopName'] ?? '',
      description: json['description'] ?? '',
      logoUrl: json['logoUrl'],
      headerImageUrl: json['headerImageUrl'],
      address: json['address'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      categories: List<String>.from(json['categories'] ?? []),
      rating: (json['rating'] ?? 0.0).toDouble(),
      totalProducts: json['totalProducts'] ?? 0,
      totalSales: json['totalSales'] ?? 0,
      isActive: json['isActive'] ?? true,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Create from Firestore DocumentSnapshot
  factory ShopModel.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ShopModel.fromJson(data);
  }

  // Create a copy with updated fields
  ShopModel copyWith({
    String? id,
    String? ownerId,
    String? ownerName,
    String? shopName,
    String? description,
    String? logoUrl,
    String? headerImageUrl,
    String? address,
    String? phoneNumber,
    String? email,
    List<String>? categories,
    double? rating,
    int? totalProducts,
    int? totalSales,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ShopModel(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      shopName: shopName ?? this.shopName,
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      headerImageUrl: headerImageUrl ?? this.headerImageUrl,
      address: address ?? this.address,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      categories: categories ?? this.categories,
      rating: rating ?? this.rating,
      totalProducts: totalProducts ?? this.totalProducts,
      totalSales: totalSales ?? this.totalSales,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

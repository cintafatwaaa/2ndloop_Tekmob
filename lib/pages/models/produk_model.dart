import 'package:cloud_firestore/cloud_firestore.dart';

class Produk {
  final String id;
  final String sellerId;
  final String sellerName;
  final String toko;
  final String name;
  final String deskripsi;
  final List<String> images;
  final int harga;
  final String category;
  final String condition;
  final String status; // 'available', 'sold', 'pending'
  final String? address;
  final DateTime createdAt;
  final DateTime updatedAt;

  Produk({
    required this.id,
    required this.sellerId,
    required this.sellerName,
    required this.toko,
    required this.name,
    required this.deskripsi,
    required this.images,
    required this.harga,
    required this.category,
    required this.condition,
    required this.status,
    this.address,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'toko': toko,
      'name': name,
      'deskripsi': deskripsi,
      'images': images,
      'harga': harga,
      'category': category,
      'condition': condition,
      'status': status,
      'address': address,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Create from Firestore document
  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      id: json['id'] ?? '',
      sellerId: json['sellerId'] ?? '',
      sellerName: json['sellerName'] ?? '',
      toko: json['toko'] ?? '',
      name: json['name'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      harga: json['harga'] ?? 0,
      category: json['category'] ?? '',
      condition: json['condition'] ?? '',
      status: json['status'] ?? 'available',
      address: json['address'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Create from Firestore DocumentSnapshot
  factory Produk.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Produk.fromJson(data);
  }

  // Create a copy with updated fields
  Produk copyWith({
    String? id,
    String? sellerId,
    String? sellerName,
    String? toko,
    String? name,
    String? deskripsi,
    List<String>? images,
    int? harga,
    String? category,
    String? condition,
    String? status,
    String? address,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Produk(
      id: id ?? this.id,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      toko: toko ?? this.toko,
      name: name ?? this.name,
      deskripsi: deskripsi ?? this.deskripsi,
      images: images ?? this.images,
      harga: harga ?? this.harga,
      category: category ?? this.category,
      condition: condition ?? this.condition,
      status: status ?? this.status,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Legacy constructor for backward compatibility
  factory Produk.legacy({
    required int no,
    required String toko,
    required String deskripsi,
    required String gambar,
    required int harga,
    required int bayar,
    required String bukti,
  }) {
    return Produk(
      id: no.toString(),
      sellerId: '',
      sellerName: '',
      toko: toko,
      name: deskripsi,
      deskripsi: deskripsi,
      images: gambar.isNotEmpty ? [gambar] : [],
      harga: harga,
      category: '',
      condition: 'used',
      status: 'available',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  // Legacy getters for backward compatibility
  int get no => int.tryParse(id) ?? 0;
  String get gambar => images.isNotEmpty ? images.first : '';
  int get bayar => harga;
  String get bukti => '';
}

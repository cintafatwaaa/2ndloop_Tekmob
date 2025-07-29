import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../models/shop_model.dart';

class ShopService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Create shop
  Future<String?> createShop(ShopModel shop) async {
    try {
      DocumentReference docRef = await _firestore
          .collection('shops')
          .add(shop.toJson());
      await docRef.update({'id': docRef.id});
      return docRef.id;
    } catch (e) {
      print('Error creating shop: $e');
      return null;
    }
  }

  // Get shop by owner ID
  Future<ShopModel?> getShopByOwner(String ownerId) async {
    try {
      QuerySnapshot snapshot =
          await _firestore
              .collection('shops')
              .where('ownerId', isEqualTo: ownerId)
              .limit(1)
              .get();

      if (snapshot.docs.isNotEmpty) {
        return ShopModel.fromDocument(snapshot.docs.first);
      }
      return null;
    } catch (e) {
      print('Error getting shop by owner: $e');
      return null;
    }
  }

  // Get shop by ID
  Future<ShopModel?> getShopById(String shopId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('shops').doc(shopId).get();
      if (doc.exists) {
        return ShopModel.fromDocument(doc);
      }
      return null;
    } catch (e) {
      print('Error getting shop: $e');
      return null;
    }
  }

  // Update shop
  Future<void> updateShop(ShopModel shop) async {
    try {
      await _firestore
          .collection('shops')
          .doc(shop.id)
          .update(shop.copyWith(updatedAt: DateTime.now()).toJson());
    } catch (e) {
      print('Error updating shop: $e');
    }
  }

  // Upload shop logo
  Future<String?> uploadShopLogo(File imageFile, String shopId) async {
    try {
      final fileName = '${shopId}_logo.jpg';
      final ref = _storage.ref().child('shop_logos/$fileName');

      final uploadTask = ref.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() => null);
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading shop logo: $e');
      return null;
    }
  }

  // Upload shop header image
  Future<String?> uploadShopHeader(File imageFile, String shopId) async {
    try {
      final fileName = '${shopId}_header.jpg';
      final ref = _storage.ref().child('shop_headers/$fileName');

      final uploadTask = ref.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() => null);
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading shop header: $e');
      return null;
    }
  }

  // Get all shops
  Stream<List<ShopModel>> getAllShops() {
    return _firestore
        .collection('shops')
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => ShopModel.fromDocument(doc)).toList(),
        );
  }

  // Search shops
  Stream<List<ShopModel>> searchShops(String query) {
    return _firestore
        .collection('shops')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => ShopModel.fromDocument(doc))
                  .where(
                    (shop) =>
                        shop.shopName.toLowerCase().contains(
                          query.toLowerCase(),
                        ) ||
                        shop.description.toLowerCase().contains(
                          query.toLowerCase(),
                        ),
                  )
                  .toList(),
        );
  }

  // Update shop statistics
  Future<void> updateShopStats(
    String shopId, {
    int? totalProducts,
    int? totalSales,
  }) async {
    try {
      Map<String, dynamic> updates = {
        'updatedAt': DateTime.now().toIso8601String(),
      };

      if (totalProducts != null) {
        updates['totalProducts'] = totalProducts;
      }

      if (totalSales != null) {
        updates['totalSales'] = totalSales;
      }

      await _firestore.collection('shops').doc(shopId).update(updates);
    } catch (e) {
      print('Error updating shop stats: $e');
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../pages/models/produk_model.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload image from XFile (works for both web and mobile)
  Future<String?> _uploadImageFromXFile(
    XFile imageFile,
    String fileName,
  ) async {
    try {
      final ref = _storage.ref().child('product_images/$fileName');

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
      print('Error uploading image: $e');
      return null;
    }
  }

  // Create product with image upload from XFile list
  Future<String?> createProductWithImages(
    Produk product,
    List<XFile> imageFiles,
  ) async {
    try {
      print('Creating product: ${product.name}');
      print('Number of images: ${imageFiles.length}');

      // Upload images first
      List<String> uploadedImageUrls = [];

      for (int i = 0; i < imageFiles.length; i++) {
        final imageFile = imageFiles[i];
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${product.name.replaceAll(' ', '_')}_$i.jpg';

        print(
          'Uploading image ${i + 1}/${imageFiles.length} to Firebase Storage: $fileName',
        );

        final downloadUrl = await _uploadImageFromXFile(imageFile, fileName);

        if (downloadUrl != null) {
          uploadedImageUrls.add(downloadUrl);
          print('Successfully uploaded image ${i + 1}: $downloadUrl');
        } else {
          print('Failed to upload image ${i + 1}');
        }
      }

      if (uploadedImageUrls.isEmpty) {
        print('No images were uploaded successfully');
        return null;
      }

      // Create product with uploaded image URLs
      final updatedProduct = Produk(
        id: product.id,
        name: product.name,
        deskripsi: product.deskripsi,
        harga: product.harga,
        category: product.category,
        condition: product.condition,
        sellerId: product.sellerId,
        sellerName: product.sellerName,
        toko: product.toko,
        address: product.address,
        images: uploadedImageUrls, // Use uploaded URLs
        createdAt: product.createdAt,
        updatedAt: product.updatedAt,
        status: product.status,
      );

      print(
        'Saving product to Firestore with ${uploadedImageUrls.length} images',
      );

      DocumentReference docRef = await _firestore
          .collection('products')
          .add(updatedProduct.toJson());
      await docRef.update({'id': docRef.id});

      print('Product created successfully with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('Error creating product: $e');
      return null;
    }
  }

  // Create product with image upload
  Future<String?> createProduct(Produk product) async {
    try {
      // Upload images first if there are local image paths
      List<String> uploadedImageUrls = [];

      for (String imagePath in product.images) {
        // Check if it's a local path (not a URL)
        if (!imagePath.startsWith('http')) {
          print('Uploading image to Firebase Storage: $imagePath');
          // Upload image to Firebase Storage
          final file = File(imagePath);
          if (await file.exists()) {
            final fileName =
                '${DateTime.now().millisecondsSinceEpoch}_${product.name.replaceAll(' ', '_')}.jpg';
            final ref = _storage.ref().child('product_images/$fileName');

            print('Firebase Storage path: product_images/$fileName');

            final uploadTask = ref.putFile(file);
            final snapshot = await uploadTask.whenComplete(() => null);
            final downloadUrl = await snapshot.ref.getDownloadURL();

            print('Firebase Storage URL: $downloadUrl');
            uploadedImageUrls.add(downloadUrl);
          } else {
            print('Local file not found: $imagePath');
          }
        } else {
          // Already a URL, keep as is
          print('Using existing URL: $imagePath');
          uploadedImageUrls.add(imagePath);
        }
      }

      // Create product with uploaded image URLs
      final updatedProduct = Produk(
        id: product.id,
        name: product.name,
        deskripsi: product.deskripsi,
        harga: product.harga,
        category: product.category,
        condition: product.condition,
        sellerId: product.sellerId,
        sellerName: product.sellerName,
        toko: product.toko,
        address: product.address,
        images: uploadedImageUrls, // Use uploaded URLs
        createdAt: product.createdAt,
        updatedAt: product.updatedAt,
        status: product.status,
      );

      DocumentReference docRef = await _firestore
          .collection('products')
          .add(updatedProduct.toJson());
      await docRef.update({'id': docRef.id});
      return docRef.id;
    } catch (e) {
      print('Error creating product: $e');
      return null;
    }
  }

  // Get all products
  Stream<List<Produk>> getAllProducts() {
    return _firestore
        .collection('products')
        .where('status', isEqualTo: 'available')
        .snapshots()
        .map((snapshot) {
          final products =
              snapshot.docs.map((doc) => Produk.fromDocument(doc)).toList();
          // Sort in memory instead of using Firestore orderBy
          products.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return products;
        });
  }

  // Get products by category
  Stream<List<Produk>> getProductsByCategory(String category) {
    return _firestore
        .collection('products')
        .where('category', isEqualTo: category)
        .where('status', isEqualTo: 'available')
        .snapshots()
        .map((snapshot) {
          final products =
              snapshot.docs.map((doc) => Produk.fromDocument(doc)).toList();
          // Sort in memory instead of using Firestore orderBy
          products.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return products;
        });
  }

  // Get products by seller
  Stream<List<Produk>> getProductsBySeller(String sellerId) {
    return _firestore
        .collection('products')
        .where('sellerId', isEqualTo: sellerId)
        .snapshots()
        .map((snapshot) {
          final products =
              snapshot.docs.map((doc) => Produk.fromDocument(doc)).toList();
          // Sort in memory instead of using Firestore orderBy
          products.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return products;
        });
  }

  // Get product by ID
  Future<Produk?> getProductById(String productId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('products').doc(productId).get();
      if (doc.exists) {
        return Produk.fromDocument(doc);
      }
      return null;
    } catch (e) {
      print('Error getting product: $e');
      return null;
    }
  }

  // Update product with image upload
  Future<void> updateProduct(Produk product) async {
    try {
      // Upload images first if there are local image paths
      List<String> uploadedImageUrls = [];

      for (String imagePath in product.images) {
        // Check if it's a local path (not a URL)
        if (!imagePath.startsWith('http')) {
          print('Updating - Uploading image to Firebase Storage: $imagePath');
          // Upload image to Firebase Storage
          final file = File(imagePath);
          if (await file.exists()) {
            final fileName =
                '${DateTime.now().millisecondsSinceEpoch}_${product.name.replaceAll(' ', '_')}.jpg';
            final ref = _storage.ref().child(
              'product_images/${product.id}/$fileName',
            );

            print(
              'Updating - Firebase Storage path: product_images/${product.id}/$fileName',
            );

            final uploadTask = ref.putFile(file);
            final snapshot = await uploadTask.whenComplete(() => null);
            final downloadUrl = await snapshot.ref.getDownloadURL();

            print('Updating - Firebase Storage URL: $downloadUrl');
            uploadedImageUrls.add(downloadUrl);
          } else {
            print('Updating - Local file not found: $imagePath');
          }
        } else {
          // Already a URL, keep as is
          print('Updating - Using existing URL: $imagePath');
          uploadedImageUrls.add(imagePath);
        }
      }

      // Create updated product with uploaded image URLs
      final updatedProduct = product.copyWith(
        images: uploadedImageUrls,
        updatedAt: DateTime.now(),
      );

      await _firestore
          .collection('products')
          .doc(product.id)
          .update(updatedProduct.toJson());
    } catch (e) {
      print('Error updating product: $e');
    }
  }

  // Delete product
  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  // Upload product images
  Future<List<String>> uploadProductImages(
    List<File> imageFiles,
    String productId,
  ) async {
    List<String> imageUrls = [];

    try {
      for (int i = 0; i < imageFiles.length; i++) {
        final file = imageFiles[i];
        final fileName = '${productId}_image_$i.jpg';
        final ref = _storage.ref().child('product_images/$productId/$fileName');

        final uploadTask = ref.putFile(file);
        final snapshot = await uploadTask.whenComplete(() => null);
        final downloadUrl = await snapshot.ref.getDownloadURL();

        imageUrls.add(downloadUrl);
      }
    } catch (e) {
      print('Error uploading images: $e');
    }

    return imageUrls;
  }

  // Search products
  Stream<List<Produk>> searchProducts(String query) {
    return _firestore
        .collection('products')
        .where('status', isEqualTo: 'available')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => Produk.fromDocument(doc))
                  .where(
                    (product) =>
                        product.name.toLowerCase().contains(
                          query.toLowerCase(),
                        ) ||
                        product.deskripsi.toLowerCase().contains(
                          query.toLowerCase(),
                        ) ||
                        product.category.toLowerCase().contains(
                          query.toLowerCase(),
                        ),
                  )
                  .toList(),
        );
  }

  // Get featured products
  Stream<List<Produk>> getFeaturedProducts({int limit = 10}) {
    return _firestore
        .collection('products')
        .where('status', isEqualTo: 'available')
        .limit(limit)
        .snapshots()
        .map((snapshot) {
          final products =
              snapshot.docs.map((doc) => Produk.fromDocument(doc)).toList();
          // Sort in memory instead of using Firestore orderBy
          products.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return products;
        });
  }
}

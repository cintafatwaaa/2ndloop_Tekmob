import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/product_service.dart';
import '../pages/models/produk_model.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();

  List<Produk> _products = [];
  List<Produk> _filteredProducts = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _selectedCategory = 'All';

  // Getters
  List<Produk> get products => _filteredProducts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get selectedCategory => _selectedCategory;

  // Load all products
  void loadProducts() {
    _isLoading = true;
    notifyListeners();

    _productService
        .getAllProducts()
        .listen((products) {
          _products = products;
          _filterProducts();
          _isLoading = false;
          notifyListeners();
        })
        .onError((error) {
          _errorMessage = error.toString();
          _isLoading = false;
          notifyListeners();
        });
  }

  // Filter products by category
  void filterByCategory(String category) {
    _selectedCategory = category;
    _filterProducts();
    notifyListeners();
  }

  // Search products
  void searchProducts(String query) {
    if (query.isEmpty) {
      _filteredProducts = _products;
    } else {
      _filteredProducts =
          _products
              .where(
                (product) =>
                    product.name.toLowerCase().contains(query.toLowerCase()) ||
                    product.deskripsi.toLowerCase().contains(
                      query.toLowerCase(),
                    ) ||
                    product.category.toLowerCase().contains(
                      query.toLowerCase(),
                    ),
              )
              .toList();
    }
    notifyListeners();
  }

  // Filter products based on selected category
  void _filterProducts() {
    if (_selectedCategory == 'All') {
      _filteredProducts = _products;
    } else {
      _filteredProducts =
          _products
              .where((product) => product.category == _selectedCategory)
              .toList();
    }
  }

  // Get products by seller
  void loadProductsBySeller(String sellerId) {
    _isLoading = true;
    notifyListeners();

    _productService
        .getProductsBySeller(sellerId)
        .listen((products) {
          _products = products;
          _filteredProducts = products;
          _isLoading = false;
          notifyListeners();
        })
        .onError((error) {
          _errorMessage = error.toString();
          _isLoading = false;
          notifyListeners();
        });
  }

  // Add product with XFile images (for both web and mobile)
  Future<bool> addProductWithImages(
    Produk product,
    List<XFile> imageFiles,
  ) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      print('ProductProvider: Adding product with ${imageFiles.length} images');
      final productId = await _productService.createProductWithImages(
        product,
        imageFiles,
      );

      if (productId != null) {
        print(
          'ProductProvider: Product added successfully with ID: $productId',
        );
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Failed to create product';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('ProductProvider error: $e');
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Add product (legacy method)
  Future<bool> addProduct(Produk product) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _productService.createProduct(product);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update product
  Future<bool> updateProduct(Produk product) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _productService.updateProduct(product);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete product
  Future<bool> deleteProduct(String productId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _productService.deleteProduct(productId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

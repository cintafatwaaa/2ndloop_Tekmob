import 'package:flutter/foundation.dart';
import '../models/shop_model.dart';
import '../services/shop_service.dart';

class ShopProvider extends ChangeNotifier {
  final ShopService _shopService = ShopService();
  ShopModel? _currentShop;
  bool _isLoading = false;
  String? _error;

  ShopModel? get currentShop => _currentShop;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get shop by owner ID
  Future<void> getShopByOwner(String ownerId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentShop = await _shopService.getShopByOwner(ownerId);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _currentShop = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get shop by ID
  Future<void> getShopById(String shopId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentShop = await _shopService.getShopById(shopId);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _currentShop = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create shop
  Future<bool> createShop(ShopModel shop) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      String? shopId = await _shopService.createShop(shop);
      if (shopId != null) {
        _currentShop = shop.copyWith(id: shopId);
        _error = null;
        notifyListeners();
        return true;
      } else {
        _error = 'Failed to create shop';
        return false;
      }
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update shop
  Future<bool> updateShop(ShopModel shop) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _shopService.updateShop(shop);
      _currentShop = shop;
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear shop data
  void clearShop() {
    _currentShop = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import '../services/transaction_service.dart';
import '../models/transaction_model.dart';

class TransactionProvider extends ChangeNotifier {
  final TransactionService _transactionService = TransactionService();

  List<TransactionModel> _transactions = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<TransactionModel> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load transactions by buyer
  void loadTransactionsByBuyer(String buyerId) {
    _isLoading = true;
    notifyListeners();

    _transactionService
        .getTransactionsByBuyer(buyerId)
        .listen((transactions) {
          _transactions = transactions;
          _isLoading = false;
          notifyListeners();
        })
        .onError((error) {
          _errorMessage = error.toString();
          _isLoading = false;
          notifyListeners();
        });
  }

  // Load transactions by seller
  void loadTransactionsBySeller(String sellerId) {
    _isLoading = true;
    notifyListeners();

    _transactionService
        .getTransactionsBySeller(sellerId)
        .listen((transactions) {
          _transactions = transactions;
          _isLoading = false;
          notifyListeners();
        })
        .onError((error) {
          _errorMessage = error.toString();
          _isLoading = false;
          notifyListeners();
        });
  }

  // Load all transactions (for admin)
  void loadAllTransactions() {
    _isLoading = true;
    notifyListeners();

    _transactionService
        .getAllTransactions()
        .listen((transactions) {
          _transactions = transactions;
          _isLoading = false;
          notifyListeners();
        })
        .onError((error) {
          _errorMessage = error.toString();
          _isLoading = false;
          notifyListeners();
        });
  }

  // Load pending transactions
  void loadPendingTransactions() {
    _isLoading = true;
    notifyListeners();

    _transactionService
        .getPendingTransactions()
        .listen((transactions) {
          _transactions = transactions;
          _isLoading = false;
          notifyListeners();
        })
        .onError((error) {
          _errorMessage = error.toString();
          _isLoading = false;
          notifyListeners();
        });
  }

  // Create transaction
  Future<bool> createTransaction(TransactionModel transaction) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _transactionService.createTransaction(transaction);
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

  // Update payment status
  Future<bool> updatePaymentStatus(
    String transactionId,
    String paymentStatus, {
    String? paymentProof,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _transactionService.updatePaymentStatus(
        transactionId,
        paymentStatus,
        paymentProof: paymentProof,
      );
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

  // Update order status
  Future<bool> updateOrderStatus(
    String transactionId,
    String orderStatus,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _transactionService.updateOrderStatus(transactionId, orderStatus);
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

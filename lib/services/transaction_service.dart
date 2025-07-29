import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart';

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create transaction
  Future<String?> createTransaction(TransactionModel transaction) async {
    try {
      DocumentReference docRef = await _firestore
          .collection('transactions')
          .add(transaction.toJson());
      await docRef.update({'id': docRef.id});
      return docRef.id;
    } catch (e) {
      print('Error creating transaction: $e');
      return null;
    }
  }

  // Get transactions by buyer
  Stream<List<TransactionModel>> getTransactionsByBuyer(String buyerId) {
    return _firestore
        .collection('transactions')
        .where('buyerId', isEqualTo: buyerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => TransactionModel.fromDocument(doc))
                  .toList(),
        );
  }

  // Get transactions by seller
  Stream<List<TransactionModel>> getTransactionsBySeller(String sellerId) {
    return _firestore
        .collection('transactions')
        .where('sellerId', isEqualTo: sellerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => TransactionModel.fromDocument(doc))
                  .toList(),
        );
  }

  // Get transaction by ID
  Future<TransactionModel?> getTransactionById(String transactionId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('transactions').doc(transactionId).get();
      if (doc.exists) {
        return TransactionModel.fromDocument(doc);
      }
      return null;
    } catch (e) {
      print('Error getting transaction: $e');
      return null;
    }
  }

  // Update transaction
  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      await _firestore
          .collection('transactions')
          .doc(transaction.id)
          .update(transaction.copyWith(updatedAt: DateTime.now()).toJson());
    } catch (e) {
      print('Error updating transaction: $e');
    }
  }

  // Update payment status
  Future<void> updatePaymentStatus(
    String transactionId,
    String paymentStatus, {
    String? paymentProof,
  }) async {
    try {
      Map<String, dynamic> updates = {
        'paymentStatus': paymentStatus,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      if (paymentProof != null) {
        updates['paymentProof'] = paymentProof;
      }

      await _firestore
          .collection('transactions')
          .doc(transactionId)
          .update(updates);
    } catch (e) {
      print('Error updating payment status: $e');
    }
  }

  // Update order status
  Future<void> updateOrderStatus(
    String transactionId,
    String orderStatus,
  ) async {
    try {
      await _firestore.collection('transactions').doc(transactionId).update({
        'orderStatus': orderStatus,
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error updating order status: $e');
    }
  }

  // Get all transactions (for admin)
  Stream<List<TransactionModel>> getAllTransactions() {
    return _firestore
        .collection('transactions')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => TransactionModel.fromDocument(doc))
                  .toList(),
        );
  }

  // Get transactions by status
  Stream<List<TransactionModel>> getTransactionsByStatus(String status) {
    return _firestore
        .collection('transactions')
        .where('orderStatus', isEqualTo: status)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => TransactionModel.fromDocument(doc))
                  .toList(),
        );
  }

  // Get pending transactions (for admin verification)
  Stream<List<TransactionModel>> getPendingTransactions() {
    return _firestore
        .collection('transactions')
        .where('paymentStatus', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => TransactionModel.fromDocument(doc))
                  .toList(),
        );
  }
}

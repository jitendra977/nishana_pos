import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GrandTotalProvider extends ChangeNotifier {
  double _grandTotal = 0;

  void updateGrandTotal() {
    _grandTotal = 0;
    final cartItems =
        FirebaseFirestore.instance.collection('cart_items').snapshots();
    cartItems.forEach((snapshot) {
      for (final item in snapshot.docs) {
        _grandTotal += item['qty'] * item['price'];
      }
    });
    notifyListeners();
  }

  double get grandTotal => _grandTotal;
}

import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GrandTotalProvider extends ChangeNotifier {
  double _grandTotal = 0;
  CollectionReference _cartItemsCollection =
      FirebaseFirestore.instance.collection('cart_items');

  double get grandTotal => _grandTotal;

  Future<void> updateGrandTotal(String tableNumber) async {
    try {
      // Fetch the cart items for the given table number
      QuerySnapshot cartItemsSnapshot = await _cartItemsCollection
          .where('table_number', isEqualTo: tableNumber)
          .get();

      double newGrandTotal = calculateGrandTotalFromCart(cartItemsSnapshot);

      // Update the grand total
      _grandTotal = newGrandTotal;

      notifyListeners();
    } catch (error) {
      // Handle any potential errors
      print('Error updating grand total: $error');
    }
  }

  double calculateGrandTotalFromCart(QuerySnapshot cartItemsSnapshot) {
    double grandTotal = 0;

    // Calculate the grand total from the cart items
    for (QueryDocumentSnapshot itemSnapshot in cartItemsSnapshot.docs) {
      Map<String, dynamic> item = itemSnapshot.data() as Map<String, dynamic>;

      // Calculate the total for each item and add it to the grand total
      double total = item['qty'] * item['price'];
      grandTotal += total;
    }

    return grandTotal;
  }
}

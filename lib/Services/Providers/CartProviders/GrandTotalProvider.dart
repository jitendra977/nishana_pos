import 'package:flutter/material.dart';

class GrandTotalProvider extends ChangeNotifier {
  double _grandTotal = 0.0;

  double get grandTotal => _grandTotal;

  void updateGrandTotal(double newTotal) {
    _grandTotal = newTotal;
    notifyListeners();
  }
}

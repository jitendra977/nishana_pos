import 'package:flutter/foundation.dart';

class CategoryProvider with ChangeNotifier {
  String _selectedCategoryName = '';

  String get selectedCategoryName => _selectedCategoryName;

  void setSelectedCategoryName(String categoryName) {
    _selectedCategoryName = categoryName;
    notifyListeners();
  }
}

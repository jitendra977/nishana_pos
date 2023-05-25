import 'package:flutter/foundation.dart';

class CategoryProvider with ChangeNotifier {
  String _selectedCategoryName = 'All';

  String get selectedCategoryName => _selectedCategoryName;

  void setSelectedCategoryName(String categoryName) {
    _selectedCategoryName = categoryName;
    notifyListeners();
  }
}

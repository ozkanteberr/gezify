import 'package:flutter/material.dart';
import 'package:gezify/presentation/home/presentation/pages/widgets/category/category_item.dart';

IconData getIconForCategory(String categoryName) {
  switch (categoryName.toLowerCase()) {
    case 'doğa':
      return Icons.nature;
    case 'tarih':
      return Icons.account_balance;
    case 'plaj':
      return Icons.beach_access;
    default:
      return Icons.category;
  }
}

List<CategoryItem> mapToCategoryItems(List<String> categories) {
  return categories
      .map((name) => CategoryItem(label: name, icon: getIconForCategory(name)))
      .toList();
}

import 'package:flutter/material.dart';
import 'package:gezify/presentation/home/presentation/pages/widgets/category/category_item.dart';

IconData getIconForCategory(String categoryName) {
  switch (categoryName.toLowerCase()) {
    case 'tümü':
      return Icons.category;
    case 'semtin favorileri':
      return Icons.account_balance;
    case 'tarihi yerler':
      return Icons.tour;
    case 'müzeler':
      return Icons.account_balance;
    case 'deniz\\sahil':
      return Icons.beach_access;
    case 'doğa\\orman':
      return Icons.forest;
    case 'yerel lezzetler\\restoranlar':
      return Icons.food_bank;
    case 'dini mekanlar':
      return Icons.nightlight_round;
    default:
      return Icons.category;
  }
}

List<CategoryItem> mapToCategoryItems(List<String> categories) {
  return categories
      .map((name) => CategoryItem(label: name, icon: getIconForCategory(name)))
      .toList();
}

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'category_item.dart'; // Güncel CategoryItem modelini kullanıyor.

class CategorySelector extends StatefulWidget {
  final List<CategoryItem> categories;
  final ValueChanged<int>? onSelected;
  final Color selectedColor;
  final Color unselectedColor;
  final double itemRadius;
  final EdgeInsetsGeometry itemPadding;

  const CategorySelector({
    Key? key,
    required this.categories,
    this.onSelected,
    this.selectedColor = Colors.black,
    this.unselectedColor = Colors.grey,
    this.itemRadius = 20,
    this.itemPadding = const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
  }) : super(key: key);

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) => _buildCategoryItem(index),
      ),
    );
  }

  Widget _buildCategoryItem(int index) {
    final category = widget.categories[index];
    final isSelected = index == _selectedIndex;
    final textColor = isSelected ? Colors.white : Colors.black;
    final iconColor = isSelected ? Colors.white : Colors.black;
    final backgroundColor = isSelected
        ? widget.selectedColor
        : widget.unselectedColor.withOpacity(0.1);

    return GestureDetector(
      onTap: () => _handleCategorySelection(index),
      child: Container(
        padding: widget.itemPadding,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(widget.itemRadius),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(category.icon, color: iconColor, size: 20),
            const SizedBox(width: 6),
            Text(
              category.label,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleCategorySelection(int index) {
    setState(() => _selectedIndex = index);
    widget.onSelected?.call(index);
  }
}

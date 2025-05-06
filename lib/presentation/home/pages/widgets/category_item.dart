// ignore_for_file: unused_import

import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String label;
  final String iconPath;

  const CategoryItem({
    required this.label,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Image.asset(
            iconPath,
            width: 20,
            height: 20,
            color: Colors.black,
            errorBuilder: (_, __, ___) => Icon(Icons.error, color: Colors.black, size: 20),
          ),
          SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

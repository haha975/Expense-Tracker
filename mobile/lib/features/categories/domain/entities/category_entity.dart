import 'package:flutter/material.dart';

enum CategoryType { expense, income }

class CategoryEntity {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final CategoryType type;
  final int transactionCount;
  final bool isCustom;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
    this.transactionCount = 0,
    this.isCustom = true,
  });
}
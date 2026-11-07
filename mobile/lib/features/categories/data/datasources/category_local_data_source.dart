import 'package:flutter/material.dart';
import '../../domain/entities/category_entity.dart';

abstract class CategoryLocalDataSource {
  Future<List<CategoryEntity>> getCategories();
  Future<void> cacheCategory(CategoryEntity category);
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final List<CategoryEntity> _categories = [
    const CategoryEntity(
      id: '1',
      name: 'Work meals',
      icon: Icons.work_outline,
      color: Colors.purple,
      type: CategoryType.expense,
      transactionCount: 0,
    ),
    const CategoryEntity(
      id: '2',
      name: 'Gifts',
      icon: Icons.card_giftcard,
      color: Colors.purpleAccent,
      type: CategoryType.expense,
      transactionCount: 0,
    ),
    const CategoryEntity(
      id: '3',
      name: 'Learning',
      icon: Icons.menu_book_outlined,
      color: Colors.deepPurple,
      type: CategoryType.expense,
      transactionCount: 0,
    ),
  ];

  @override
  Future<List<CategoryEntity>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _categories;
  }

  @override
  Future<void> cacheCategory(CategoryEntity category) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _categories.insert(0, category);
  }
}
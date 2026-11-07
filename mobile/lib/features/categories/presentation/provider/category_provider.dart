import 'package:flutter/material.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepository repository;

  CategoryProvider({required this.repository}) {
    loadCategories();
  }

  List<CategoryEntity> _categories = [];
  List<CategoryEntity> get categories => _categories;

  CategoryType _selectedTab = CategoryType.expense;
  CategoryType get selectedTab => _selectedTab;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Form states for creating a new category
  final TextEditingController nameController = TextEditingController(text: 'Fitness');
  IconData selectedIcon = Icons.fitness_center;
  Color selectedColor = Colors.purple;

  final List<IconData> availableIcons = [
    Icons.fitness_center,
    Icons.favorite_border,
    Icons.directions_bike,
    Icons.music_note,
    Icons.school_outlined,
    Icons.coffee_outlined,
  ];

  void setTab(CategoryType type) {
    _selectedTab = type;
    notifyListeners();
  }

  void selectIcon(IconData icon) {
    selectedIcon = icon;
    notifyListeners();
  }

  Future<void> loadCategories() async {
    _isLoading = true;
    notifyListeners();
    try {
      _categories = await repository.getCategories();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createCategory() async {
    if (nameController.text.trim().isEmpty) return;

    final newCat = CategoryEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: nameController.text.trim(),
      icon: selectedIcon,
      color: selectedColor,
      type: _selectedTab,
      transactionCount: 0,
      isCustom: true,
    );

    await repository.addCategory(newCat);
    nameController.clear();
    await loadCategories();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }
}
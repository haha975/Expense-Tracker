import '../../domain/entities/budget_category_entity.dart';

abstract class BudgetLocalDataSource {
  Future<List<BudgetCategoryEntity>> getBudgetCategories();
}

class BudgetLocalDataSourceImpl implements BudgetLocalDataSource {
  @override
  Future<List<BudgetCategoryEntity>> getBudgetCategories() async {
    return const [
      BudgetCategoryEntity(
        id: '1',
        categoryName: 'Food & Dining',
        iconName: 'restaurant',
        spentAmount: 1200,
        budgetLimit: 2000,
      ),
      BudgetCategoryEntity(
        id: '2',
        categoryName: 'Shopping',
        iconName: 'shopping_bag',
        spentAmount: 750,
        budgetLimit: 1500,
      ),
      BudgetCategoryEntity(
        id: '3',
        categoryName: 'Transportation',
        iconName: 'directions_car',
        spentAmount: 450,
        budgetLimit: 1000,
      ),
      BudgetCategoryEntity(
        id: '4',
        categoryName: 'Subscriptions',
        iconName: 'sync',
        spentAmount: 90,
        budgetLimit: 100,
      ),
    ];
  }
}
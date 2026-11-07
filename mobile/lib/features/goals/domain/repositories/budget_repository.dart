
import '../entities/budget_category_entity.dart';

abstract class BudgetRepository {
  Future<List<BudgetCategoryEntity>> getBudgetCategories();
}

import '../entities/budget_category_entity.dart';
import '../repositories/budget_repository.dart';

class GetBudgetCategoriesUseCase {
  final BudgetRepository repository;

  GetBudgetCategoriesUseCase(this.repository);

  Future<List<BudgetCategoryEntity>> call() {
    return repository.getBudgetCategories();
  }
}
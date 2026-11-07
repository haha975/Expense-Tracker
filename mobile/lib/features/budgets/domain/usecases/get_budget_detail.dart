import '../entities/budget_detail.dart';
import '../repositories/budget_repository.dart';

class GetBudgetDetail {
  final BudgetRepository repository;

  GetBudgetDetail(this.repository);

  Future<BudgetDetail> call(String budgetId) async {
    return await repository.getBudgetDetail(budgetId);
  }
}